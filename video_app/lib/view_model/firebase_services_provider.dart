import 'package:flutter/material.dart';
import 'package:video_app/services/firestore_services.dart';

class FirebaseServicesProvider extends ChangeNotifier {
  late final FirestoreServices _firestoreServices;

  FirebaseServicesProvider({required FirestoreServices firestoreServices})
      : _firestoreServices = firestoreServices;

  Future<void> uploadFile({
    required String fileName,
    required String videoFile,
  }) async {
    await _firestoreServices.uploadFileToFirebase(
      fileName: fileName,
      videoFile: videoFile,
    );
  }
}
