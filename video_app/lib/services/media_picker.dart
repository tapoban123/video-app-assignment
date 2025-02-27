import 'package:image_picker/image_picker.dart';

/// Allows the user to select a video their device.
Future<String?> pickVideo() async {
  final picker = ImagePicker();
  final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

  XFile? video = pickedVideo;

  return video?.path;
}
