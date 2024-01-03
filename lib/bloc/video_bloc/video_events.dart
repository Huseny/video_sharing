import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();
}

class AddInitial extends VideoEvent {
  @override
  List<Object?> get props => [];
}

class LoadVideo extends VideoEvent {
  @override
  List<Object?> get props => [];
}

class InitializeVideoUpload extends VideoEvent {
  @override
  List<Object?> get props => [];
}

class UploadVideo extends VideoEvent {
  final String path;
  final String title;
  final String author;
  final String description;

  const UploadVideo(
      {required this.path,
      required this.title,
      required this.author,
      required this.description});

  @override
  List<Object?> get props => [title, author, description];
}
