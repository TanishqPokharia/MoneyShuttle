import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_swift/data/month_list.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profile_photo/profile_photo.dart';

class TransactionHistoryTile extends StatelessWidget {
  final TransactionHistory transactionHistory;

  const TransactionHistoryTile({super.key, required this.transactionHistory});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListTile(
      onTap: () {
        showNote(context);
      },
      leading: Consumer(
        builder: (_, WidgetRef ref, __) {
          return ProfilePhoto(
              totalWidth: context.rSize(70),
              cornerRadius: context.rSize(100),
              color: Colors.indigo,
              fontColor: Colors.white,
              name: transactionHistory.userHistory.username,
              nameDisplayOption: NameDisplayOptions.initials,
              fit: BoxFit.cover,
              image: ref
                  .watch(
                      profilePhotoProvider(transactionHistory.userHistory.msId))
                  .when(
                    loading: () => null,
                    error: (error, stackTrace) {
                      print(error);
                      return null;
                    },
                    data: (data) => CachedNetworkImageProvider(data),
                  ));
        },
      ),
      title: Text(
        transactionHistory.userHistory.username,
        style: context.textSmall!.copyWith(),
      ),
      subtitle: Text(
        "${transactionHistory.userHistory.time}, ${transactionHistory.userHistory.date} ${monthList[transactionHistory.userHistory.month - 1]} ${transactionHistory.userHistory.year}",
        style: context.textSmall!.copyWith(),
      ),
      trailing: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${transactionHistory.userHistory.amount.substring(0, 1)} ₹${transactionHistory.userHistory.amount.substring(1)}",
                style: transactionHistory.userHistory.amount.contains("-")
                    ? context.textMedium!.copyWith(color: Colors.red)
                    : context.textMedium!.copyWith(color: Colors.green)),
            transactionHistory.categoryIcon
          ],
        ),
      ),
    );
  }

  Future<dynamic> showNote(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        showDragHandle: true,
        backgroundColor: context.backgroundColor,
        builder: (context) {
          return Container(
            width: double.infinity,
            height: context.rSize(300),
            padding: EdgeInsets.all(context.rSize(20)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.rSize(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Transaction ID",
                //   style: context.textMedium,
                // ),
                // Divider(
                //   color: Colors.grey,
                // ),
                // Text(
                //   "ID: ",
                //   style: context.textMedium,
                // ),
                // SizedBox(
                //   height: context.rSize(20),
                // ),
                Text(
                  "Note",
                  style: context.textMedium,
                ),
                Divider(
                  color: Colors.grey,
                ),
                Text(
                  transactionHistory.userHistory.note,
                  style: context.textSmall!
                      .copyWith(fontSize: context.rSize(20)),
                )
              ],
            ),
          );
        },
      );
  }
}
