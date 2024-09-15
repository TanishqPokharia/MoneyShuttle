import 'package:cash_swift/models/chat_data/chat_data.dart';
import 'package:cash_swift/providers/chat/chat_messages_provider.dart';
import 'package:cash_swift/services/chat_service/chat_service.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    super.key,
    required this.chatData,
    required this.msIdUser,
  });
  final ChatData chatData;
  final String msIdUser;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatUser user = ChatUser(
        id: msIdUser,
        firstName: FirebaseAuth.instance.currentUser!.displayName);
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(onTap: () {}, child: Text(chatData.username)),
        ),
        body: DashChat(
            inputOptions: InputOptions(
              inputTextStyle: context.textMedium,
              inputDecoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: context.textMedium!.copyWith(color: Colors.grey),
                  iconColor: context.iconColor,
                  fillColor: context.backgroundColor,
                  filled: true),
              sendButtonBuilder: (send) {
                return IconButton(onPressed: send, icon: Icon(Icons.send));
              },
            ),
            currentUser: user,
            onSend: (message) {
              final chatMessage = ChatMessage(
                  text: message.text, user: user, createdAt: DateTime.now());
              ChatService.sendMessage(
                  userID: msIdUser,
                  receiverID: chatData.msId,
                  chatMessage: chatMessage);
            },
            // messages: [],
            messages: ref
                .watch(chatMessageProvider(
                    ChatService.makeChatRoomId(msIdUser, chatData.msId)))
                .when(
              error: (error, stackTrace) {
                print(error);
                return [];
              },
              loading: () {
                print("loading");
                return [];
              },
              data: (data) {
                return data.map((e) => ChatMessage.fromJson(e)).toList();
              },
            )));
  }
}
