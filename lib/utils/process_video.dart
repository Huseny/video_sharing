// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:video_compress/video_compress.dart';

// class ProcessVideo {
//   Future<File> compressVideo(String videoPath) async {
//     try {
//       MediaInfo? compressedVideo = await VideoCompress.compressVideo(videoPath,
//           quality: VideoQuality.DefaultQuality);

//       return compressedVideo!.file!;
//     } catch (e) {
//       debugPrint(e.toString());
//       rethrow;
//     }
//   }

//   Future<File> generateThumbnail(String path) async {
//     try {
//       File thumbnail = await VideoCompress.getFileThumbnail(path);
//       return thumbnail;
//     } catch (e) {
//       debugPrint(e.toString());
//       rethrow;
//     }
//   }
// }
