import 'package:image_picker/image_picker.dart';

Future<String?> pickVideo() async {
  final picker = ImagePicker();
  final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

  XFile? video = pickedVideo;

  return video?.path;
}
