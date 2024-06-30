import 'package:cash_swift/data/month_list.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/transaction_history.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';

class TransactionHistoryTile extends StatelessWidget {
  final TransactionHistory transactionHistory;

  const TransactionHistoryTile({super.key, required this.transactionHistory});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          backgroundColor: appBackgroundColor,
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
                  Text(
                    "Transaction ID",
                    style: context.textMedium!.copyWith(),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    "ID: ",
                    style: context.textMedium,
                  ),
                  SizedBox(
                    height: context.rSize(20),
                  ),
                  Text(
                    "Remark",
                    style: context.textMedium!.copyWith(),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    transactionHistory.note ?? "",
                    style: context.textMedium!.copyWith(),
                  )
                ],
              ),
            );
          },
        );
      },
      leading: ProfilePhoto(
        totalWidth: context.rSize(70),
        cornerRadius: context.rSize(100),
        color: Colors.purple,
        fontColor: Colors.white,
        name: transactionHistory.name,
        nameDisplayOption: NameDisplayOptions.initials,
      ),
      title: Text(
        transactionHistory.name,
        style: context.textSmall!.copyWith(),
      ),
      subtitle: Text(
        "${transactionHistory.time}, ${transactionHistory.date} ${monthList[transactionHistory.month - 1]} ${transactionHistory.year}",
        style: context.textSmall!.copyWith(),
      ),
      trailing: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "${transactionHistory.amount.substring(0, 1)} ₹${transactionHistory.amount.substring(1)}",
                style: transactionHistory.amount.contains("-")
                    ? context.textMedium!.copyWith(color: Colors.red)
                    : context.textMedium!.copyWith(color: Colors.green)),
            transactionHistory.categoryIcon
          ],
        ),
      ),
    );
  }
}
