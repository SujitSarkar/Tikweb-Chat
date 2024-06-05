import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/router/app_router.dart';

class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  Future<void> manageAuthGuard(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      if (FirebaseAuth.instance.currentUser != null) {
        context.goNamed(AppRoutes.homeRoute);
      } else {
        context.goNamed(AppRoutes.authRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => manageAuthGuard(context));
      return null;
    }, []);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
