import 'dart:convert';
import 'dart:io';
import '../../../../core/constants/app_string.dart';
import '../data/chat_repository.dart';
import '../domain/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/db_collection.dart';
import '../../../../shared/utils/app_toast.dart';
import 'package:http/http.dart' as http;

class ChatService implements ChatRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool?> saveMassage(
      {required ChatMessage chatMessage, required String chatRoomId}) async {
    try {
      await _firestore
          .collection(DBCollection.chatRoom)
          .doc(chatRoomId)
          .collection(DBCollection.message)
          .add(chatMessage.toMap());
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
  Future<void> sendNotification(
      {required String senderName,
      required String receiverToken,
      required String message}) async {
    final data = <String, dynamic>{
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'title': '$senderName sent you a message!',
      'body': message
      // 'receiver': receiverId,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=${AppString.serverKey}'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': '$senderName sent you a message!',
                  'body': message
                },
                'priority': 'high',
                'data': data,
                'to': receiverToken
              }));
      if (response.statusCode == 200) {
        debugPrint('Push notification success');
      } else {
        debugPrint('Push notification failed!');
      }
    } catch (e) {
      debugPrint('Push notification error: $e');
    }
  }
}
