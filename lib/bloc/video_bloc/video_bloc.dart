import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_events.dart';
import 'package:videoapp/bloc/video_bloc/video_states.dart';
import 'package:videoapp/repository/data_providers/video_data_provider.dart';
import 'package:videoapp/repository/models/video_model.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoInitial()) {
    final VideoDataProvider videoDataProvider = VideoDataProvider();
    on<AddInitial>(
      (event, emit) {
        emit(const VideoInitial());
      },
    );
    on<LoadVideo>((event, emit) async {
      if (state is VideoLoading) return;
      emit(const VideoLoading());
      try {
        List<VideoModel> videos = await videoDataProvider.fetchVideos();
        emit(VideoLoadedSuccess(videos: videos));
      } catch (error) {
        emit(VideoLoadingFailure(error: error));
      }
    });

    on<InitializeVideoUpload>(
      (event, emit) {
        emit(VideoUploadingInitial());
      },
    );

    on<UploadVideo>(
      (event, emit) async {
        if (state is VideoUploading) return;
        emit(VideoUploading());
        try {
          final String id = "${event.path.split("/").last}${DateTime.now()}";

          final Uint8List? videoThumbnail =
              await videoDataProvider.generateThumbnail(event.path, event.path);
          final String thumbnailUrl = videoThumbnail != null
              ? await videoDataProvider.uploadThumbnail(id, videoThumbnail)
              : "https://picsum.photos/200/300";

          String videoUrl = await videoDataProvider.uploadVideo(id, event.path);

          await videoDataProvider.uploadVideoDescription(VideoModel(
              id: id,
              videoUrl: videoUrl,
              title: event.title,
              author: event.author,
              description: event.description,
              createdAt: DateTime.now(),
              thumbnailUrl: thumbnailUrl));
          emit(VideoUploadSuccess());
        } catch (error) {
          debugPrint(error.toString());
          emit(VideoUploadFailure(error: error));
        }
      },
    );
  }
}
