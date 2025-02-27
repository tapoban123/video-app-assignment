import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_app/firebase_options.dart';
import 'package:video_app/services/firestore_services.dart';
import 'package:video_app/view/home_screen.dart';
import 'package:video_app/view_model/firebase_services_provider.dart';
import 'package:video_app/view_model/media_picker_provider.dart';
import 'package:video_app/view_model/video_player_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MediaPickerProvider()),
        ChangeNotifierProvider(
            create: (_) => FirebaseServicesProvider(
                firestoreServices: FirestoreServices())),
        ChangeNotifierProvider(
          create: (_) => VideoPlayerProvider(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: "Video App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.dark,
        home: HomeScreen(),
      ),
    );
  }
}
