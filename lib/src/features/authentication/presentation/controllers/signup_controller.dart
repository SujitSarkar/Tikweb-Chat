import '../../../../../shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../application/auth_service.dart';

abstract class SignupState {}

class InitialState extends SignupState {}

class LoadingState extends SignupState {}

final signupProvider = StateNotifierProvider<SignupController, SignupState>(
    (ref) => SignupController(AuthService()));

class SignupController extends StateNotifier<SignupState> {
  SignupController(this._authService) : super(InitialState());
  final AuthService _authService;

  final GlobalKey<FormState> signupFormKey = GlobalKey();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void clearData() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> userSignup(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) {
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showToast('Password does not match');
      return;
    }
    state = LoadingState();
    await _authService
        .signup(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((credential) async {
      if (credential != null) {
        await _authService
            .saveUser(
                id: credential.user!.uid,
                email: emailController.text.trim(),
                name: nameController.text.trim())
            .then((value) {
          if (value != null && value == true) {
            debugPrint('$value');
            showToast('Successfully signed up');
            clearData();
            context.goNamed(AppRoutes.homeRoute);
          }
        });
      }
    });

    state = InitialState();
  }
}
