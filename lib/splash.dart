import 'package:egypttourguide/Screens/bottom_navigation.dart';
import 'package:egypttourguide/main.dart';
import 'package:egypttourguide/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Authentication/google_auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 1), () {
      _navigate();
    });
  }

  Future<void> _navigate() async {
    bool? seen = getStorage.read('onboardingComplete');

    if (seen == null || !seen) {
      getStorage.write('onboardingComplete', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } else {
      FirebaseAuth.instance.currentUser != null
          ? Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => const BottomNavBar()))
          : Get.to(const GoogleAuth());
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo_guru.jpg"),
          ),
          //TODO: image is missing
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 35, 218, 224), Color.fromARGB(255, 5, 179, 170)],
          ),
        ),
        // child: Image.asset(
        //   "images/logo.jpg",
        // ),
      ),
    ));
  }
}
