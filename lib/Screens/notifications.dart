import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotifyService {
  Future<void> initFCMService() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('*** Notification initial message');
        handleNotification(message);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('*** Notification On Message');
      handleNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      debugPrint('*** Notification Message Opened');
      handleNotification(message);
    });
  }

  void handleNotification(RemoteMessage msg) {
    showNotify(msg.notification?.title ?? 'title', msg.notification?.body ?? 'body');
  }

  Future<void> initService() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/branding',
        [
          NotificationChannel(
            channelKey: 'guru',
            channelName: 'Guru',
            channelDescription: 'Guide Alert',
            playSound: true,
            onlyAlertOnce: true,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            importance: NotificationImportance.Max,
            criticalAlerts: true,
            channelShowBadge: true,
            enableVibration: true,
            locked: false,
          )
        ],
        debug: true);
  }

  void showNotify(String title, String body) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'guru',
            color: Colors.white,
            title: title,
            body: body,
            criticalAlert: true));
  }

  Future<void> sendNotification(String token) async {
    String title = 'Tourist booked you as a Guide';
    String body = 'Please click to open the details';
    Map<String, dynamic> data = {'title': title, 'body': body};
    sendPushMessageForTokens(title, body, data, token);
  }

  Future<void> sendPushMessageForTokens(
      String title, String body, Map<String, dynamic> data, String token) async {
    var headers = {
      'Authorization':
          'Bearer ya29.a0AXooCgtvqmtQtAPYXMW1hu3UOybCOcUVd12jWn0ml-FYM6Ng-aYRs5tQPv6qDtPhN6QWj9s4x841qaDkka40VWjIlxEdSPl0sS8KVOVuj7I2dmfJZdKSK6KMbchkK4MTGRHVk9Q33jmLQU2iXCoHGqGJyQDcRzpClCd8aCgYKAfASARASFQHGX2MiywGE_ijG6X5a1eguMYLNGg0171',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://fcm.googleapis.com/v1/projects/egypttourguide/messages:send'));
    request.body = json.encode({
      "message": {
        "token": token,
        "notification": {"body": body, "title": title},
        "data": data
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    debugPrint('*** Notification status - ${response.statusCode == 200}');
  }
}
