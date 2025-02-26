import 'package:flutter/material.dart';
import 'package:video_app/model/video_data_model.dart';
import 'package:video_app/services/firestore_services.dart';

class FirebaseServicesProvider extends ChangeNotifier {
  late final FirestoreServices _firestoreServices;

  FirebaseServicesProvider({required FirestoreServices firestoreServices})
      : _firestoreServices = firestoreServices;

  // String? _videoUrl = null;
  // String? get videoUrl => _videoUrl;
  List<VideoDataModel> _videosData = [];
  List<VideoDataModel> get videosData => _videosData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadFile({
    required String fileName,
    required String videoFile,
  }) async {
    await _firestoreServices.uploadFileToFirebase(
      fileName: fileName,
      videoFile: videoFile,
    );
  }

  // Future<void> getVideoUrl(String fileName) async {}

  Future<void> getAllVideos() async {
    _setLoading(true);
    _videosData = await _firestoreServices.getAllFiles();
    _setLoading(false);
  }
}
