import '../../../../../core/constants/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.documentSnapshot});
  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
    final bool currentUser =
        data['senderId'] == FirebaseAuth.instance.currentUser!.uid;
    final message = data['message'];

    return Container(
      margin: currentUser
          ? EdgeInsets.only(
              left: message.length < 20
                  ? 200
                  : message.length < 40
                      ? 100
                      : 50)
          : EdgeInsets.only(
              right: message.length < 20
                  ? 200
                  : message.length < 40
                      ? 100
                      : 50),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: currentUser
              ? AppColors.primaryColor
              : Colors.grey.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      alignment: currentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        message,
        style: TextStyle(
            color: currentUser ? Colors.white : Colors.grey.shade900,
            fontSize: 16),
      ),
    );
  }
}
