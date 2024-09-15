import 'package:cash_swift/providers/chat/chat_list_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen(this.msIdUser, {super.key});

  final String msIdUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        body: ref.watch(chatListProvider).when(
              error: (error, stackTrace) {
                print(error);
                return Center(
                  child: Text("Oops! Could not fetch data",
                      style: context.textMedium),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              data: (data) {
                if (data.isEmpty) {
                  return Center(
                    child: Text("No chats yet", style: context.textMedium),
                  );
                } else {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ChatTile(
                        chatData: data[index],
                        msIdUser: msIdUser,
                      );
                    },
                  );
                }
              },
            ));
  }
}
