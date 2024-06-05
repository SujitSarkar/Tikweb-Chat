import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoginScreen = useState(true);
    void toggleScreen() => isLoginScreen.value = !isLoginScreen.value;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 450 : double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoginScreen.value
                    ? const LoginScreen()
                    : const SignupScreen(),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor),
                    children: [
                      TextSpan(
                          text: isLoginScreen.value
                              ? 'Don\'t have an account? '
                              : 'Already have an account? '),
                      TextSpan(
                        text: isLoginScreen.value ? 'Signup' : "Login",
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            toggleScreen();
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
