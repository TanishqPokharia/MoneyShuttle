import 'dart:convert';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  void requestPerms() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            criticalAlert: true,
            provisional: true,
            sound: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("access granted");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisional permission granted");
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print("access denied");
    }
  }

  void initLocalNotification(BuildContext context) async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        GoRouter.of(context).go("/splash");
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            "CashSwiftChannelID", "High Importance Notification",
            importance: Importance.high);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidNotificationChannel.id, androidNotificationChannel.name,
            channelDescription: "Transaction Notification Channel",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");

    await flutterLocalNotificationPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(android: androidNotificationDetails));
    print(message.notification!.title);
    print(message.notification!.body);
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null && context.mounted) {
      GoRouter.of(context).go("/splash");
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      GoRouter.of(context).go("/splash");
    });
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void initFirebase(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      initLocalNotification(context);
      showNotification(event);
    });
  }

  Future<String> getDeviceToken() async {
    final token = await firebaseMessaging.getToken();
    return token!;
  }

  static void sendNotification(
      {required String userToken,
      required String receiverToken,
      required String userNotificationBody,
      required receiverNotificationBody}) async {
    final userData = {
      "to": userToken,
      "priority": "high",
      "notification": {"title": "CashSwift", "body": userNotificationBody},
      "android": {
        "notification": {"channel_id": "CashSwiftChannelID"}
      }
    };

    final receiverData = {
      "to": receiverToken,
      "priority": "high",
      "notification": {"title": "CashSwift", "body": receiverNotificationBody},
      "android": {
        "notification": {"channel_id": "CashSwiftChannelID"}
      }
    };

    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
              "key=AAAAPWpX-Lw:APA91bECro8FXq_SQaZ18OVHvvDDpPKKbSZA_p_B1tJC5LJyiN3GJ9X8AB2W_PpMZLx0oR08TVhveYKxTXQGGBmsRAFFx0046m2HQ6j3gNWNZT2cpcn0ccYgvXBYDDwXlBjvDzc15Kzg"
        },
        body: jsonEncode(userData));

    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
              "key=AAAAPWpX-Lw:APA91bECro8FXq_SQaZ18OVHvvDDpPKKbSZA_p_B1tJC5LJyiN3GJ9X8AB2W_PpMZLx0oR08TVhveYKxTXQGGBmsRAFFx0046m2HQ6j3gNWNZT2cpcn0ccYgvXBYDDwXlBjvDzc15Kzg"
        },
        body: jsonEncode(receiverData));
  }
}
