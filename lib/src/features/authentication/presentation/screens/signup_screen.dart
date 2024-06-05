import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../shared/widgets/solid_button.dart';
import '../../../../../shared/widgets/text_field_widget.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final SignupState state = ref.watch(signupProvider);
      final signupController = ref.read(signupProvider.notifier);
      return Form(
        key: signupController.signupFormKey,
        child: Column(
          children: [
            const Text(
              "Create new account to start your journey",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 24),
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: signupController.nameController,
              hintText: "Full name",
              textCapitalization: TextCapitalization.words,
              required: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: signupController.emailController,
              hintText: "Email address",
              textInputType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: signupController.passwordController,
              hintText: "Password",
              textInputType: TextInputType.visiblePassword,
              required: true,
              obscure: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: signupController.confirmPasswordController,
              hintText: "Confirm password",
              textInputType: TextInputType.visiblePassword,
              required: true,
              obscure: true,
            ),
            const SizedBox(height: 40),
            SolidButton(
                onTap: () => signupController.userSignup(context),
                isLoading: state is LoadingState,
                child: const Text(
                  'Signup',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
      );
    });
  }
}
