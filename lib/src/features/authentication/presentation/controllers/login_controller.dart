import '../../../../../shared/utils/app_toast.dart';
import '../../../../../core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LoginState {}

class InitialState extends LoginState {}

class LoadingState extends LoginState {}

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
    (ref) => LoginController(AuthService()));

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._authService) : super(InitialState());
  final AuthService _authService;

  final GlobalKey<FormState> loginFormKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void clearData() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> userLogin(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
    state = LoadingState();
    await _authService
        .login(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((credential) {
      if (credential != null) {
        showToast('Successfully logged in');
        clearData();
        context.goNamed(AppRoutes.homeRoute);
      }
    });
    state = InitialState();
  }
}
