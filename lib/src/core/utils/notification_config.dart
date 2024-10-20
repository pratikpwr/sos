import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sos_app/src/app.dart';
import 'package:sos_app/src/features/auth/repository/auth_repository.dart';
import 'package:sos_app/src/features/sos_details/screen/receiver_sos_alert_screen.dart';

import '../injector/injection_container.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationConfig {
  static Future<bool> permissionStatus() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  static init() async {
    if (await permissionStatus()) {
      addTokenListener();
      fcmToken();
      checkInitialMessage();
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    }
  }

  static Future<String?> fcmToken({int? userId}) async =>
      await FirebaseMessaging.instance.getToken().then((token) async {
        if (token != null) {
          final deviceInfo = sl<AuthRepository>();
          await deviceInfo.sendFCMToken(fcmToken: token, userId: userId);
        }
        return token;
      });

  static void addTokenListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      final deviceInfo = sl<AuthRepository>();

      await deviceInfo.sendFCMToken(fcmToken: fcmToken);
    });
  }

  /// initialize flutter local notification plugin
  /// with android and ios settings
  static initLocalNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: androidSetting,
      ),
    );
  }

  static Future<void> setupForegroundMessaging(BuildContext context) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    initLocalNotification(flutterLocalNotificationsPlugin);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'SOS APP Notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// this executes when app is running in background
    /// i.e. it is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) {
        return ReceiverAlertScreen(sosId: int.parse(message.data['SOSId']));
      }));
    });

    /// this executes when app is running
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        final androidDetails = AndroidNotificationDetails(
          channel.id,
          channel.name,
          priority: Priority.max,
          importance: Importance.max,
          enableVibration: true,
        );

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: androidDetails,
          ),
        );
      }
    });
  }

  /// this executes when app is closed
  static Future<void> checkInitialMessage() async {
    /// Added delay as on initial launch app needs to load Dashboard Screen
    /// on which we will push the next screen which is decided from
    /// notification data
    await Future.delayed(const Duration(seconds: 1));
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    debugPrint("Initial message $initialMessage");
    if (initialMessage != null) {}
  }
}
