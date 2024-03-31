import 'package:cash_swift/main.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/transaction_loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransactionStatusScreen extends ConsumerWidget {
  const TransactionStatusScreen(
      {super.key,
      required this.transactionStatus,
      required this.amount,
      required this.receiverName,
      required this.receiverPhoneNumber,
      required this.receiverID});
  final bool transactionStatus;
  final String amount;
  final String receiverName;
  final String receiverPhoneNumber;
  final String receiverID;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message =
        transactionStatus ? "Payment Successful!" : "Payment Failed";
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: appBackgroundColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(mq(context, 20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
                  child: Text(
                    receiverName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
                  child: Text(
                    receiverID,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                transactionStatus
                    ? Image.asset("assets/payment_success.gif")
                    : Image.asset("assets/payment_failure.gif"),
                Container(
                  margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: Colors.white,
                        size: mq(context, 45),
                      ),
                      Text(
                        amount,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: mq(context, 30)),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
                  child: TextButton(
                      onPressed: () {
                        GoRouter.of(context).go("/home/payment");
                      },
                      child: Text(
                        "Make another payment",
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
                  child: TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.indigo)),
                      onPressed: () {
                        GoRouter.of(context).go("/home");
                      },
                      child: Text(
                        "Go Back",
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
