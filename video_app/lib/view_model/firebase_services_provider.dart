import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_app/model/video_data_model.dart';
import 'package:video_app/services/firestore_services.dart';

/// Provider to connect FirebaseServices with HomeScreen UI.
class FirebaseServicesProvider extends ChangeNotifier {
  late final FirestoreServices _firestoreServices;

  FirebaseServicesProvider({required FirestoreServices firestoreServices})
      : _firestoreServices = firestoreServices;

  // String? _videoUrl = null;
  // String? get videoUrl => _videoUrl;
  UploadTask? _uploadTask;
  UploadTask? get uploadTask => _uploadTask;

  List<VideoDataModel> _videosData = [];
  List<VideoDataModel> get videosData => _videosData;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isCheckingFile = false;
  bool get isCheckingFile => _isCheckingFile;

  bool _isFileExisting = false;
  bool get isFileExisting => _isFileExisting;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadFile({
    required String fileName,
    required String videoFile,
  }) async {
    _uploadTask = await _firestoreServices.uploadFileToFirebase(
      fileName: fileName,
      videoFile: videoFile,
    );
  }

  Future<void> deleteVideo({
    required String fileName,
  }) async {
    _videosData.removeWhere(
      (element) => element.name == fileName,
    );
    notifyListeners();
    await _firestoreServices.deleteVideoFile(fileName: fileName);
  }

  Future<void> isFileExistingCheck(String fileName) async {
    _isCheckingFile = true;
    notifyListeners();
    try {
      await _firestoreServices.checkIfFileExists(fileName: fileName);
      _isFileExisting = true;
    } catch (e) {
      _isFileExisting = false;
      debugPrint(e.toString());
    }
    debugPrint(_isFileExisting.toString());
    _isCheckingFile = false;
    notifyListeners();
  }

  Future<void> getAllVideos() async {
    if (_isLoading == false) {
      _setLoading(true);
    }
    _videosData = await _firestoreServices.getAllFiles();
    _setLoading(false);
  }
}
