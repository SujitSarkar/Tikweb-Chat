// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import '../data/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/db_collection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/utils/app_toast.dart';

class AuthService implements AuthRepository {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  factory AuthService() => instance;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserCredential?> login(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showToast("Invalid credentials");
      } else {
        showToast(e.message ?? "");
      }
    } on SocketException {
      showToast('No internet connection');
    } catch (error) {
      showToast(error.toString());
    }
    return null;
  }

  @override
  Future<UserCredential?> signup(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast('User already exist');
      } else {
        showToast(e.message ?? "Something went wrong");
      }
    } on SocketException {
      showToast('No internet connection');
    } catch (error) {
      showToast(error.toString());
    }
    return null;
  }

  @override
  Future<String?> getFcmToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (error) {
      return null;
    }
  }

  @override
  Future<bool?> saveUser(
      {required String id, required String email, required String name}) async {
    try {
      final fcmToken = await getFcmToken();
      await _firestore.collection(DBCollection.user).doc(id).set({
        'id': id,
        'email': email,
        'name': name,
        'fcmToken': fcmToken,
      });
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      showToast(e.message ?? "Something went wrong");
      return false;
    } on SocketException {
      showToast('No internet connection');
      return false;
    } catch (error) {
      debugPrint(error.toString());
      showToast(error.toString());
      return false;
    }
  }

  @override
  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      context.goNamed(AppRoutes.authRoute);
    } on SocketException {
      showToast('No internet connection');
    } catch (error) {
      debugPrint(error.toString());
      showToast(error.toString());
    }
  }
}
