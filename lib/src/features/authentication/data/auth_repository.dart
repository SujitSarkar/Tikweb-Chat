import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  Future<UserCredential?> login(
      {required String email, required String password});

  Future<UserCredential?> signup(
      {required String email, required String password});

  Future<String?> getFcmToken();

  Future<bool?> saveUser(
      {required String id, required String email, required String name});

  Future<void> logout(BuildContext context);
}
