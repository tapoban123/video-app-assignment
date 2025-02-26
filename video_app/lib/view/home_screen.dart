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
            child: TextButton(
              onPressed: () {
                Provider.of<MediaPickerProvider>(
                  context,
                  listen: false,
                ).selectVideo();
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
          // if (mediaProvider.videoPath != null) {
          //   return ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => VideoPlayerScreen(),
          //       ));
          //     },
          //     style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     child: Text("Play Video"),
          //   );
          // }
          // return Center(
          //   child: Text("Your Videos will appear here."),
          // );
        },
      ),
    );
  }
}
