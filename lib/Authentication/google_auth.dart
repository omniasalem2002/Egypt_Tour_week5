import 'package:egypttourguide/Backend/users.dart';
import 'package:egypttourguide/Models/profile_model.dart';
import 'package:egypttourguide/Screens/bottom_navigation.dart';
import 'package:egypttourguide/main.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import '../utils/colors_app.dart';

class GoogleAuth extends StatefulWidget {
  const GoogleAuth({super.key});

  @override
  State<GoogleAuth> createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  Users users = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorsApp.primaryColor, ColorsApp.semiPrimaryColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Lottie.asset('assets/images/travel_login.json'),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                    'Welcome to Egypt Tour Guide App. Please sign in using your google account to continue.',
                    maxLines: 3)),
            InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 60),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/google_logo.png'))),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Google SignIn',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              onTap: () {
                signInWithGoogle();
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        EasyLoading.show();
        UserCredential? cred =
            await FirebaseAuth.instance.signInWithCredential(credential);
        bool response = await users.checkUser(cred.user?.uid ?? '');
        getStorage.write('uid', cred.user?.uid ?? '');
        if (!response) {
          ProfileModel model = ProfileModel(
              uid: cred.user?.uid ?? '',
              name: cred.user?.displayName ?? '',
              mail: cred.user?.email ?? '',
              image: cred.user?.photoURL ?? '',
              role: 'USER',
              phoneNumber: '',
              whatsappNumber: '',
              token: await getToken(),
              timestamp: DateTime.now());
          await users.createUser(model);
        }
        if (EasyLoading.isShow) EasyLoading.dismiss();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavBar()),
        );
      }
    } on FirebaseAuthException catch (e) {
      showToast('Google SignIn Failed $e');
    }
  }
}
