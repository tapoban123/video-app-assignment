import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/view/video_player_screen.dart';
import 'package:video_app/view_model/media_picker_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: Consumer<MediaPickerProvider>(
        builder: (context, mediaProvider, child) {
          if (mediaProvider.videoPath != null) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(),
                ));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Play Video"),
            );
          }
          return Center(
            child: Text("Your Videos will appear here."),
          );
        },
      ),
    );
  }
}
