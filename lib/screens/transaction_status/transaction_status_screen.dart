import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/transaction_status.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class TransactionStatusScreen extends ConsumerWidget {
  const TransactionStatusScreen({
    super.key,
    required this.transactionStatus,
  });
  final TransactionStatus transactionStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message =
        transactionStatus.status ? "Payment Successful!" : "Payment Failed";
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: appBackgroundColor,
          height: context.screenHeight,
          width: context.screenWidth,
          padding: EdgeInsets.all(context.rSize(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: context.rSize(10)),
                child: Text(
                  transactionStatus.receiverName ?? "Error",
                  style: context.textLarge,
                ),
              ),
              Container(
                child: Text(
                  "+91 ${transactionStatus.receiverPhone}" ?? "Error",
                  style: context.textMedium,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: context.rSize(10)),
                child: Text(
                  transactionStatus.receiverId ?? "Error",
                  style: context.textMedium,
                ),
              ),
              transactionStatus.status
                  ? Lottie.asset("assets/PaymentSuccessRocket.json",
                      fit: BoxFit.cover)
                  : Lottie.asset("assets/PaymentFailureRocket.json",
                      fit: BoxFit.cover),
              Container(
                margin: EdgeInsets.symmetric(vertical: context.rSize(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: Colors.white,
                      size: context.rSize(45),
                    ),
                    Text(
                      transactionStatus.amount ?? "-",
                      style: context.textLarge,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: context.rSize(30)),
                child: Text(
                  message,
                  style: context.textLarge,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: context.rSize(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Make another payment",
                      style: context.textMedium,
                    )),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: context.rSize(10)),
                child: TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.indigo)),
                    onPressed: () {
                      GoRouter.of(context).go("/home");
                    },
                    child: Text(
                      "Go Back",
                      style: context.textMedium,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
