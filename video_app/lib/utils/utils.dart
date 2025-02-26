import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String bytesToMB(int bytes) {
  return (bytes / 1_048_576).toStringAsFixed(2);
}

String formatDate(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}

String formatTime(DateTime time) {
  return DateFormat.jm().format(time);
}

Widget customCircularProgressIndicator() {
  return Center(
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    ),
  );
}

double screenHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}

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
