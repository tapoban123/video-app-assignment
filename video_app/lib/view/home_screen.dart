import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/utils/utils.dart';
import 'package:video_app/view/components/dialog_text_button.dart';
import 'package:video_app/view/video_player_screen.dart';
import 'package:video_app/view_model/firebase_services_provider.dart';
import 'package:video_app/view_model/media_picker_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<FirebaseServicesProvider>(
      context,
      listen: false,
    ).getAllVideos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Consumer<MediaPickerProvider>(
              builder: (context, mediaProvider, child) => TextButton(
                onPressed: () async {
                  await mediaProvider.selectVideo();
                  if (mediaProvider.videoPath != null && context.mounted) {
                    showUploadToFirebaseDialog(
                      context,
                      filePath: mediaProvider.videoPath!,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(100, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FirebaseServicesProvider>(
        builder: (context, mediaProvider, child) {
          if (mediaProvider.isLoading) {
            return customCircularProgressIndicator();
          }

          if (mediaProvider.videosData.isEmpty) {
            return Center(
              child: Text("No Videos Availalble"),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => mediaProvider.getAllVideos(),
              child: ListView.builder(
                itemCount: mediaProvider.videosData.length,
                itemBuilder: (context, index) {
                  final videoData = mediaProvider.videosData[index];

                  return ListTile(
                    leading: Icon(Icons.video_file),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(videoData.name),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDeleteConfirmDialog(
                                  context,
                                  fileName: videoData.name,
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                pageRouteNavigationAnimation(
                                  context,
                                  VideoPlayerScreen(
                                    videoUrl: videoData.videoUrl,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${bytesToMB(videoData.size ?? 0)} MB",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          formatTime(videoData.creationDateTime!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          formatDate(videoData.creationDateTime!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

void showDeleteConfirmDialog(
  BuildContext context, {
  required String fileName,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Are you sure you want to delete $fileName?"),
      actions: [
        DialogTextButton(
          buttonColor: Colors.blue,
        ),
        DialogTextButton(
          buttonText: "Delete",
          onPressed: () {
            Provider.of<FirebaseServicesProvider>(
              context,
              listen: false,
            ).deleteVideo(fileName: fileName);

            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}

void showUploadToFirebaseDialog(
  BuildContext context, {
  required String filePath,
}) {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  );
  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red),
  );

  // final fileIsExisting =
  //     Provider.of<FirebaseServicesProvider>(context).isFileExisting;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Text("Please name your file"),
          SizedBox(
            width: 10,
          ),
          Consumer<FirebaseServicesProvider>(
            builder: (context, firebaseProvider, child) {
              if (firebaseProvider.isCheckingFile) {
                return SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          )
        ],
      ),
      content: SizedBox(
        height: 80,
        width: screenWidth(context) * 0.7,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: border,
                  filled: true,
                  focusedBorder: border,
                  focusedErrorBorder: errorBorder,
                  errorBorder: errorBorder,
                  hintText: "Enter file name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a valid file name.";
                  }
                  return null;
                },
              ),
              Consumer<FirebaseServicesProvider>(
                builder: (context, firebaseProvider, child) {
                  if (firebaseProvider.isFileExisting) {
                    debugPrint(firebaseProvider.isFileExisting.toString());
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "File name already exists",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
      actions: [
        DialogTextButton(),
        DialogTextButton(
          buttonColor: Colors.blue,
          buttonText: "Upload",
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              debugPrint("Validated");
              final String fileName = "${nameController.text.trim()}.mp4";

              Provider.of<FirebaseServicesProvider>(
                context,
                listen: false,
              ).isFileExistingCheck(fileName).then(
                (value) async {
                  final isFilePresent = context.mounted &&
                      Provider.of<FirebaseServicesProvider>(context,
                              listen: false)
                          .isFileExisting;

                  debugPrint(isFilePresent.toString());
                  if (context.mounted && !isFilePresent) {
                    await Provider.of<FirebaseServicesProvider>(
                      context,
                      listen: false,
                    ).uploadFile(
                      fileName: fileName,
                      videoFile: filePath,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showDialogLoader(context);
                    }
                    debugPrint("File Exists: $isFilePresent");
                    debugPrint("File uploaded successfully.");
                  }
                },
              );
            } else {
              debugPrint("Validation Failed");
            }
          },
        ),
      ],
    ),
  );
}
