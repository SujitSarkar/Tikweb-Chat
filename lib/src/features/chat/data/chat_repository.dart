import '../domain/chat_message.dart';

abstract class ChatRepository {
  Future<bool?> saveMassage(
      {required ChatMessage chatMessage, required String chatRoomId});

  Future<void> sendNotification(
      {required String senderName,
      required String receiverToken,
      required String message});
}
