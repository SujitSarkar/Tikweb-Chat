import 'dart:async';
import '../../../../../core/constants/db_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../account/domain/user.dart';
import '../../../../../shared/utils/app_toast.dart';
import '../../../account/application/account_service.dart';
import '../../domain/chat_message.dart';
import '../../application/chat_service.dart';

abstract class ChatState {}

class InitialState extends ChatState {}

class LoadingState extends ChatState {}

final chatProvider = StateNotifierProvider<ChatController, ChatState>(
    (ref) => ChatController(ChatService()));

class ChatController extends StateNotifier<ChatState> {
  ChatController(this._chatService) : super(InitialState());
  final ChatService _chatService;

  final GlobalKey<FormState> loginFormKey = GlobalKey();
  final messageController = TextEditingController();
  final passwordController = TextEditingController();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  void clearData() {
    messageController.clear();
  }

  Future<void> getUser() async {
    final result = await AccountService.instance.getCurrentUser();
    if (result != null) {
      userModel = result;
    }
  }

  //Send message
  Future<void> sendMessage(
      {required String receiverId, required String receiverToken}) async {
    if (messageController.text.isEmpty) {
      showToast("Write message first");
      return;
    }
    state = LoadingState();
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //Create new message
    ChatMessage newMessage = ChatMessage(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: messageController.text.trim(),
        timestamp: timestamp);

    clearData();
    //construct chat room id from current user id and receiver id (sorted ensure uniqueness)
    final String chatRoomId = generateChatRoomId(
        currentUserId: currentUserId, receiverId: receiverId);
    await _chatService
        .saveMassage(chatMessage: newMessage, chatRoomId: chatRoomId)
        .then((value) {
      if (value != null && value == true) {
        sendNotification(
            receiverToken: receiverToken, message: newMessage.message);
      }
    });
    state = InitialState();
  }

  Future<void> sendNotification(
      {required String receiverToken, required String message}) async {
    if (receiverToken == 'not_found') {
      return;
    }
    if (userModel == null) {
      await getUser();
    }
    await _chatService.sendNotification(
        senderName: userModel!.name!,
        receiverToken: receiverToken,
        message: message);
  }

  Stream<QuerySnapshot> getMessages({required String otherId}) {
    final String userId = _firebaseAuth.currentUser!.uid;
    final String chatRoomId =
        generateChatRoomId(currentUserId: userId, receiverId: otherId);

    return _firestore
        .collection(DBCollection.chatRoom)
        .doc(chatRoomId)
        .collection(DBCollection.message)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  String generateChatRoomId(
      {required String currentUserId, required String receiverId}) {
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    return ids.join("_");
  }
}
