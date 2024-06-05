import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Page not found!"),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => context.goNamed(AppRoutes.homeRoute),
                  child: const Text('Go To Home'))
            ],
          ),
        ),
      ),
    );
  }
}
