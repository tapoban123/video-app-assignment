import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_app/view/home_screen.dart';
import 'package:video_app/view_model/firebase_services_provider.dart';

/// Converts bytesToMb
String bytesToMB(int bytes) {
  return (bytes / 1_048_576).toStringAsFixed(2);
}

/// Formats DateTime to readable Date.
String formatDate(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}

/// Formats DateTime to readable Time.
String formatTime(DateTime time) {
  return DateFormat.jm().format(time);
}

/// Displays SnackBar with message.
void showSnackBarMessage(
  BuildContext context, {
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ),
  );
}

/// Displays loader inside a Dialog.
/// Implemented on [HomeScreen].
void showDialogLoader(BuildContext context, {bool removeLoader = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final uploadTask =
          Provider.of<FirebaseServicesProvider>(context).uploadTask;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: uploadTask?.snapshotEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                if (data.bytesTransferred == data.totalBytes) {
                  Navigator.of(context).pop();
                }
                final progress = data.bytesTransferred / data.totalBytes;
                return customCircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                );
              }
              return SizedBox.shrink();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Please wait while your file is being uploaded.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      );
    },
  );
}

/// Returns a custom circularProgressIndicator.
Widget customCircularProgressIndicator({
  double? value,
  Color? backgroundColor,
}) {
  return Center(
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
      value: value,
      backgroundColor: backgroundColor,
    ),
  );
}

/// Returns current height of screen.
double screenHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

/// Returns current width of screen.
double screenWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

/// Create animation when navigating to another page.
void pageRouteNavigationAnimation(
  BuildContext context,
  Widget navigateToPage,
) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => navigateToPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final position =
          Tween(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastEaseInToSlowEaseOut,
      ));

      return SlideTransition(
        position: position,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 300),
  ));
}
