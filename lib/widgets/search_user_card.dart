import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/providers/home/transaction_cleanup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class SearchUserTile extends ConsumerWidget {
  const SearchUserTile({super.key, required this.cashSwiftUser});

  final CashSwiftUser cashSwiftUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.all(context.rSize(20)),
      onTap: () {
        ref
            .read(transactionCleanUpProvider.notifier)
            .cleanUpTransactionData(ref);
        GoRouter.of(context)
            .go("/home/payment/transaction", extra: cashSwiftUser);
      },
      leading: ProfilePhoto(
        totalWidth: context.rSize(50),
        cornerRadius: context.rSize(25),
        color: Colors.grey,
        name: cashSwiftUser.username,
        nameDisplayOption: NameDisplayOptions.initials,
        fontColor: Colors.white,
        image: ref.watch(profilePhotoProvider(cashSwiftUser.id!)).when(
              loading: () => null,
              error: (error, stackTrace) {
                print(error);
                return null;
              },
              data: (data) => CachedNetworkImageProvider(data),
            ),
      ),
      title: Text(cashSwiftUser.username,
          style: context.textMedium!.copyWith(fontSize: context.rSize(22))),
      subtitle: Text(
        "+91 ${cashSwiftUser.phoneNumber!}",
        style: context.textMedium!.copyWith(fontSize: context.rSize(22)),
      ),
    );
  }
}
