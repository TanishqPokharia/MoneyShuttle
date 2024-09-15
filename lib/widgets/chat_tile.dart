import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_swift/models/chat_data/chat_data.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.msIdUser,
    required this.chatData,
  });

  final ChatData chatData;
  final String msIdUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        chatData.username,
        style: context.textMedium,
      ),
      subtitle: Text(
        "Tap to view messages",
        style: context.textSmall,
      ),
      leading: Consumer(
        builder: (_, WidgetRef ref, __) {
          return ProfilePhoto(
            cornerRadius: context.rSize(60),
            totalWidth: context.rSize(60),
            color: Colors.grey,
            fit: BoxFit.cover,
            image: ref.watch(profilePhotoProvider(chatData.msId)).when(
                  error: (error, stackTrace) {
                    print(error);
                    return null;
                  },
                  loading: () => null,
                  data: (data) {
                    return CachedNetworkImageProvider(data);
                  },
                ),
          );
        },
      ),
      onTap: () {
        GoRouter.of(context).push("/home/chatlist/chat",
            extra: {"msIdUser": msIdUser, "chatData": chatData});
      },
    );
  }
}
