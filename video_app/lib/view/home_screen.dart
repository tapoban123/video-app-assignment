import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/utils/utils.dart';
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
                    uploadToFirebaseDialog(context);
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
                        IconButton(
                          onPressed: () {
                            pageRouteNavigationAnimation(
                              context,
                              VideoPlayerScreen(
                                videoUrl: videoData.videoUrl,
                              ),
                            );
                          },
                          icon: Icon(Icons.play_arrow),
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

void uploadToFirebaseDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text("Please name your file"),
      content: SizedBox(
        height: 80,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: "Enter file name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a valid file name";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              debugPrint("Validated");
            }
            debugPrint("Validation Failed");
          },
          child: Text("Upload"),
        ),
      ],
    ),
  );
}
