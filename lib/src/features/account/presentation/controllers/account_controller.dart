import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/account_service.dart';
import '../../domain/user.dart';

abstract class AccountState {}

class InitialState extends AccountState {}

class UserLoadingState extends AccountState {}

class UserLoadedState extends AccountState {
  UserLoadedState({required this.userModel});
  final UserModel userModel;
}

final accountProvider = StateNotifierProvider<AccountController, AccountState>(
    (ref) => AccountController(AccountService()));

class AccountController extends StateNotifier<AccountState> {
  AccountController(this._accountService) : super(InitialState());
  final AccountService _accountService;

  final GlobalKey<FormState> loginFormKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> getUser() async {
    state = UserLoadingState();
    await _accountService.getCurrentUser().then((value) {
      if (value != null) {
        state = UserLoadedState(userModel: value);
      }
    });
  }
}
