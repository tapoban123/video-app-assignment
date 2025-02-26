import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_app/model/video_data_model.dart';

class FirestoreServices {
  final ref = FirebaseStorage.instance.ref();
  final String folderName = "video-files";

  Future<void> uploadFileToFirebase({
    required String fileName,
    required String videoFile,
  }) async {
    final path = "$folderName/$fileName";
    final file = File(videoFile);

    final snapshot = await ref.child(path).putFile(file);
    final url = await snapshot.ref.getDownloadURL();
    debugPrint(url);
  }

  Future<void> deleteVideoFile({
    required String fileName,
  }) async {
    final path = "$folderName/$fileName";
    await ref.child(path).delete();
  }

  Future<void> checkIfFileExists({
    required String fileName,
  }) async {
    final path = "$folderName/$fileName";

    try {
      final url = await ref.child(path).getDownloadURL();
      debugPrint(url);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VideoDataModel>> getAllFiles() async {
    final List<VideoDataModel> videosData = [];

    final path = folderName;
    final result = await ref.child(path).listAll();

    for (final item in result.items) {
      final videoMeta = await item.getMetadata();
      final url = await item.getDownloadURL();

      final video = VideoDataModel(
        name: item.name,
        videoUrl: url,
        creationDateTime: videoMeta.timeCreated,
        size: videoMeta.size,
      );

      videosData.add(video);
    }

    return videosData;
  }
}
