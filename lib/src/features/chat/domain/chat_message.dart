import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  ChatMessage(
      {required this.senderId,
      required this.senderEmail,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp':
          timestamp, // Firestore requires a specific format for timestamps
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] as String,
      senderEmail: map['senderEmail'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp']
          as Timestamp, // Assuming you have Timestamp handling set up
    );
  }
}
