import 'package:equatable/equatable.dart';
import 'package:videoapp/repository/models/video_model.dart';


abstract class VideoState extends Equatable {
  const VideoState();
}

class VideoInitial extends VideoState {
  const VideoInitial();

  @override
  List<Object?> get props => [];
}

class VideoLoading extends VideoState {
  const VideoLoading();

  @override
  List<Object?> get props => [];
}

class VideoLoadedSuccess extends VideoState {
  final List<VideoModel> videos;
  const VideoLoadedSuccess({required this.videos});

  @override
  List<Object?> get props => videos;
}

class VideoLoadingFailure extends VideoState {
  final Object error;

  const VideoLoadingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class VideoUploadingInitial extends VideoState {
  @override
  List<Object?> get props => [];
}

class VideoUploading extends VideoState {
  @override
  List<Object?> get props => [];
}

class VideoUploadSuccess extends VideoState {
  @override
  List<Object?> get props => [];
}

class VideoUploadFailure extends VideoState {
  final Object error;

  const VideoUploadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}