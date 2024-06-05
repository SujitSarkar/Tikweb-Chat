import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/utils/app_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_string.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'shared/service/push_notification_service.dart';

@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage message) async {
  if (message.notification != null) {
    debugPrint('::::onBackgroundMessage::::');
    debugPrint('\nNotification Title: ${message.notification?.title}');
    debugPrint('\nNotification Body: ${message.notification?.body}');
    debugPrint('\nNotification Payload: ${message.data}');

    if (NavigatorKey.key.currentState != null) {
      NavigatorKey.key.currentState!.context.goNamed(AppRoutes.homeRoute);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    await FirebasePushApiService().initNotification();
    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.routes,
      key: NavigatorKey.key,
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme: AppThemes.lightTheme,
      themeMode: ThemeMode.light,
    );
  }
}
