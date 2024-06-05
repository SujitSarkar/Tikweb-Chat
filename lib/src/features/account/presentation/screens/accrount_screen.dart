import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../shared/widgets/loading_widget.dart';
import '../../../authentication/application/auth_service.dart';
import '../controllers/account_controller.dart';

class AccountScreen extends HookWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);

    return Consumer(builder: (context, ref, child) {
      final AccountState state = ref.watch(accountProvider);
      final accountController = ref.read(accountProvider.notifier);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (counter.value == 0) {
          accountController.getUser();
          counter.value++;
        }
      });

      return Scaffold(
          appBar: AppBar(
            title: const Text('Account'),
            elevation: 0.0,
            titleSpacing: 0.0,
          ),
          body: state is UserLoadingState
              ? const LoadingWidget()
              : state is UserLoadedState
                  ? Center(
                      child: SizedBox(
                        width: kIsWeb ? 450 : double.infinity,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(0.3),
                                radius: 50,
                                child: const Icon(
                                  CupertinoIcons.person,
                                  size: 60,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.userModel.name ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.userModel.email ?? 'N/A',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                  onPressed: () =>
                                      AuthService.instance.logout(context),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 16),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text('No data found')));
    });
  }
}
