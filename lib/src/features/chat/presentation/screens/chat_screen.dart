import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../shared/widgets/loading_widget.dart';
import '../../../../../shared/widgets/text_field_widget.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {super.key,
      required this.reveiverId,
      required this.reveiverName,
      required this.reveiverToken});
  final String? reveiverId;
  final String? reveiverName;
  final String? reveiverToken;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final ChatController chatController = ref.read(chatProvider.notifier);
      return Scaffold(
          appBar: AppBar(
            title: Text(reveiverName ?? 'N/A'),
            elevation: 0.0,
            titleSpacing: 0.0,
          ),
          body: Center(
            child: Container(
              margin: kIsWeb ? const EdgeInsets.symmetric(vertical: 40) : null,
              width: kIsWeb ? 480 : double.infinity,
              color: kIsWeb ? Colors.grey.shade100 : null,
              child: Column(
                children: [
                  Expanded(child: _buildMessageList(chatController)),
                  _buildMessageInput(chatController)
                ],
              ),
            ),
          ));
    });
  }

  Widget _buildMessageList(ChatController chatController) => StreamBuilder(
      stream: chatController.getMessages(otherId: reveiverId ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.hasData) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            addAutomaticKeepAlives: false,
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ChatTile(documentSnapshot: snapshot.data!.docs[index]);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      });

  Widget _buildMessageInput(ChatController chatController) => Container(
        padding: const EdgeInsets.only(bottom: 16, left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: TextFormFieldWidget(
              controller: chatController.messageController,
              hintText: "Write message",
              minLine: 1,
              maxLine: 5,
              textInputType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            )),
            IconButton(
                onPressed: () {
                  chatController.sendMessage(
                      receiverId: reveiverId ?? '',
                      receiverToken: reveiverToken ?? '');
                },
                icon: const Icon(
                  Icons.send,
                  color: AppColors.primaryColor,
                  size: 32,
                ))
          ],
        ),
      );
}
