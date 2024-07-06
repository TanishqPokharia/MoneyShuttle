import 'package:cash_swift/models/transaction_history.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/widgets/transaction_history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen(
      {super.key, required this.balance, required this.transactionHistoryList});
  final String? balance;
  final List<TransactionHistory> transactionHistoryList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text("Balance"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.rSize(20)),
            child: Text(
              "Current Account Balance: ",
              style: context.textMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.currency_rupee_sharp),
              Text(balance ?? "Could not fetch balance",
                  style: context.textMedium),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
                left: context.rSize(20), top: context.rSize(80)),
            alignment: Alignment.centerLeft,
            child: Text(
              "Last 5 debits from account",
              style: context.textMedium,
            ),
          ),
          ...transactionHistoryList.map((e) {
            return TransactionHistoryTile(transactionHistory: e);
          })
        ],
      ),
    );
  }
}
