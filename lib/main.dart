import 'package:country_code_picker/country_code_picker.dart';
import 'package:egypttourguide/splash.dart';
import 'package:egypttourguide/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'Screens/notifications.dart';
import 'firebase_options.dart';

late GetStorage getStorage;

Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint('***Background ${message.toMap()}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await GetStorage.init();

  NotifyService notifyService = NotifyService();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await notifyService.initService();
  await notifyService.initFCMService();
  initStorage();
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Guru',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      supportedLocales: const [Locale("en")],
      localizationsDelegates: const [CountryLocalizations.delegate],
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const Splash(),
    );
  }
}
