import 'package:cash_swift/extensions.dart';
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
      onTap: () {
        ref
            .read(transactionCleanUpProvider.notifier)
            .cleanUpTransactionData(ref);
        GoRouter.of(context)
            .go("/home/payment/transaction", extra: cashSwiftUser);
      },
      leading: Container(
        margin: EdgeInsets.only(right: context.rSize(20)),
        child: ProfilePhoto(
          totalWidth: context.rSize(90),
          cornerRadius: context.rSize(50),
          color: Colors.purple,
          name: cashSwiftUser.username,
          nameDisplayOption: NameDisplayOptions.initials,
          fontColor: Colors.white,
        ),
      ),
      title: Text(cashSwiftUser.username,
          style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        cashSwiftUser.phoneNumber!,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
