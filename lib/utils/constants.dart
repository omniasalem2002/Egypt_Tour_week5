import 'package:egypttourguide/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

void initStorage() {
  getStorage = GetStorage();
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

List<String> getCities() {
  return [
    'Cairo',
    'giza',
    'Luxor',
    'Aswan',
    'Alexandria',
    'Sharm El Sheikh',
    'Hurghada',
    'Dahab',
    'Siwa Oasis',
    'Marsa Alam',
    'Port Said',
  ];
}

Future<String> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token ?? '';
}

String netImgPlaceholder =
    'https://firebasestorage.googleapis.com/v0/b/egypttourguide.appspot.com/o/user.jpg?alt=media&token=ba5d058a-f600-4df3-9388-d2c4d0d6b17e';

int stringToInt(String value) {
  int temp = 0;
  try {
    temp = int.parse(value);
  } catch (e) {
    debugPrint('*** Int Parsing');
  }
  return temp;
}

String getPhoneNUmber(String value) {
  List<String> l1 = value.split('/');
  if (l1.length > 2) return l1[2];
  return '';
}

String getCountryCode(String value) {
  List<String> l1 = value.split('/');
  if (l1.length > 2) return l1[0];
  return '';
}

String getDialCode(String value) {
  List<String> l1 = value.split('/');
  if (l1.length > 2) return l1[1];
  return '';
}
