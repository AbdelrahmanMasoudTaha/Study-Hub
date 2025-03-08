import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_hub/splash.dart';
import 'package:study_hub/view/Screens/OCR_screen/ocr_img_screen.dart';
import 'package:study_hub/view/Screens/homescreen.dart';
import 'package:study_hub/view/Screens/login_screen.dart';
import 'package:study_hub/view/Screens/to_do_screen.dart';
import 'package:study_hub/view/Screens/translate_screen.dart';

import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Study Hub",
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const TranslateScreen(),
      // StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const SplashScreen();
      //     }
      //     if (snapshot.hasData) {
      //       final authUser = FirebaseAuth.instance.currentUser!;

      //       return HomeScreen();
      //     }
      //     return const LoginScreen();
      //   },
      // ),
    );
  }
}
