import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/models/user_history/user_history.dart';
import 'package:cash_swift/providers/home/transaction_cleanup_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class RecentTransaction extends ConsumerWidget {
  const RecentTransaction({
    super.key,
    required this.userHistory,
  });

  final UserHistory userHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullname = userHistory.username.split(" ");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfilePhoto(
          name: userHistory.username,
          nameDisplayOption: NameDisplayOptions.initials,
          totalWidth: context.rSize(70),
          cornerRadius: context.rSize(100),
          color: Colors.indigo,
          fontColor: Colors.white,
          fit: BoxFit.cover,
          image: ref.watch(profilePhotoProvider(userHistory.msId)).when(
                loading: () => null,
                error: (error, stackTrace) {
                  print(error);
                  return null;
                },
                data: (data) => CachedNetworkImageProvider(data),
              ),
          onTap: () async {
            ref
                .read(transactionCleanUpProvider.notifier)
                .cleanUpTransactionData(ref);
            final receiverData = await FirebaseFirestore.instance
                .collection("users")
                .where("msId", isEqualTo: userHistory.msId)
                .get();
            final receiverBalance = receiverData.docs.first.data()['balance'];
            print(receiverBalance);
            GoRouter.of(context).go("/home/transaction",
                extra: CashSwiftUser(
                    email: null,
                    username: userHistory.username,
                    id: userHistory.msId,
                    balance: receiverBalance.toDouble(),
                    phoneNumber: userHistory.phone));
          },
        ),
        SizedBox(
          width: context.rSize(150),
          child: Text(
            fullname.first,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textSmall!.copyWith(fontSize: context.rSize(20)),
          ),
        ),
        SizedBox(
          width: context.rSize(150),
          child: Text(
            fullname.last,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textSmall!.copyWith(fontSize: context.rSize(20)),
          ),
        ),
      ],
    );
  }
}
