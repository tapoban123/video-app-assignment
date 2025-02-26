import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  final ref = FirebaseStorage.instance.ref();

  Future<void> uploadFileToFirebase({
    required String fileName,
    required String videoFile,
  }) async {
    final path = "video-files/$fileName";
    final file = File(videoFile);

    await ref.child(path).putFile(file);
  }

  Future<void> fetchFiles()async{
    // Not implemented yet.
  }
}
