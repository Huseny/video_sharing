import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videoapp/repository/models/video_model.dart';

class VideoDataProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<VideoModel>> fetchVideos() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("videos").get();
      return querySnapshot.docs
          .map((e) => VideoModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadVideoDescription(VideoModel videoModel) async {
    try {
      await _firebaseFirestore
          .collection("videos")
          .doc(videoModel.id)
          .set(videoModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadVideo(String id, String path) async {
    try {
      TaskSnapshot taskSnapshot =
          await _firebaseStorage.ref("videos/$id").putFile(File(path));
      return taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadThumbnail(String id, Uint8List data) async {
    try {
      TaskSnapshot taskSnapshot = await _firebaseStorage
          .ref("Thumbnails/$id")
          .putData(data, SettableMetadata(contentType: "image/jpeg"));
      return taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List?> generateThumbnail(
      String videoPath, String thumbnailPath) async {
    try {
      final thumbnailFile = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        quality: 75,
      );
      return thumbnailFile;
    } catch (e) {
      return null;
    }
  }
}
