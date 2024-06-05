import '../../../../../shared/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../shared/widgets/solid_button.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final LoginState state = ref.watch(loginProvider);
      final loginController = ref.read(loginProvider.notifier);
      return Form(
        key: loginController.loginFormKey,
        child: Column(
          children: [
            const Text(
              'Welcome back',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 24),
            ),
            const SizedBox(height: 32),
            TextFormFieldWidget(
              controller: loginController.emailController,
              hintText: "Email address",
              textInputType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: loginController.passwordController,
              hintText: "Password",
              textInputType: TextInputType.visiblePassword,
              required: true,
              obscure: true,
            ),
            const SizedBox(height: 40),
            SolidButton(
                onTap: () {
                  loginController.userLogin(context);
                },
                isLoading: state is LoadingState,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
      );
    });
  }
}
