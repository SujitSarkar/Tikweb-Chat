import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../utils/app_context.dart';

class FirebasePushApiService {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationChannel androidChannel =
      const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.max);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await getUserPermission();
    final fcmToken = await firebaseMessaging.getToken();
    debugPrint('Device FCM token is: $fcmToken');

    await initPushNotification();
    await initLocalNotification();
  }

  Future<void> firebaseMessagingBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  Future<void> initPushNotification() async {
    ///for IOS
    firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    /// Get any messages which caused the application to open from a terminated state.
    firebaseMessaging.getInitialMessage().then((value) => handleMessage);

    /// Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    /// Get any messages application in foreground
    FirebaseMessaging.onMessage.listen(handleForegroundMessage);
  }

  Future<void> handleForegroundMessage(RemoteMessage? message) async {
    if (message != null) {
      debugPrint('::::onForegroundMessage::::');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification == null) return;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  icon: android.smallIcon //'@drawable/ic_launcher'
                  ),
            ),
            payload: jsonEncode(message.toMap()));
      }
    }
  }

  Future<void> handleMessage(RemoteMessage message) async {
    if (message.notification != null) {
      debugPrint('::::handleMessage::::');
      debugPrint('\nNotification Title: ${message.notification?.title}');
      debugPrint('\nNotification Body: ${message.notification?.body}');
      debugPrint('\nNotification Payload: ${message.data}');
      // Navigator.pushNamed(AppNavigatorKey.key.currentState!.context, AppRouter.orderList);
      if (NavigatorKey.key.currentState != null) {
        NavigatorKey.key.currentState!.context.goNamed(AppRoutes.homeRoute);
      }
    }
  }

  Future<void> getUserPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> initLocalNotification() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
      handleMessage(message);
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
}
