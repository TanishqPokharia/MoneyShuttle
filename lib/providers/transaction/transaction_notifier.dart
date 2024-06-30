import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/models/transaction_status.dart';
import 'package:cash_swift/models/user_history/user_history.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/providers/transaction/category_list_provider.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/transaction_status_provider.dart';
import 'package:cash_swift/router/router_config.dart';
import 'package:cash_swift/widgets/loading_rocket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, void>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<void> {
  TransactionNotifier() : super(());

  initiateTransaction(context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Colors.transparent,
          child: Container(
              alignment: Alignment.center,
              height: context.rSize(100),
              child: SizedBox(
                height: context.rSize(100),
                width: context.rSize(100),
                child: CircularProgressIndicator(),
              )),
        );
      },
    );
  }

  Future<void> validatePin(BuildContext context, WidgetRef ref, String pin,
      CashSwiftUser cashSwiftUser) async {
    final savedContext = context;
    initiateTransaction(savedContext);
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          elevation: 5,
          insetAnimationDuration: const Duration(milliseconds: 300),
          insetAnimationCurve: Curves.easeIn,
          child: Container(
            height: context.rSize(300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter PIN",
                  style: context.textMedium!.copyWith(color: Colors.black),
                ),
                Container(
                  height: context.rSize(100),
                  child: Pinput(
                    keyboardType: TextInputType.phone,
                    cursor: Container(
                      color: Colors.black,
                      width: context.rSize(3),
                      height: context.rSize(30),
                    ),
                    isCursorAnimationEnabled: true,
                    showCursor: true,
                    obscureText: true,
                    obscuringWidget: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      width: context.rSize(15),
                      height: context.rSize(15),
                    ),
                    validator: (value) {
                      return value == pin ? null : "Wrong PIN";
                    },
                    errorBuilder: (errorText, pin) {
                      return Container(
                        margin: EdgeInsets.all(context.rSize(10)),
                        child: Text(errorText!,
                            style:
                                context.textSmall!.copyWith(color: Colors.red)),
                      );
                    },
                    autofocus: true,
                    onCompleted: (value) async {
                      await beginTransacting(savedContext, ref, cashSwiftUser);
                    },
                  ),
                ),
                SizedBox(
                  width: context.rSize(120),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  beginTransacting(BuildContext savedContext, WidgetRef ref,
      CashSwiftUser cashSwiftUser) async {
    Navigator.pop(savedContext);

    ref.read(categoryListProvider.notifier).isAnyCategorySelected();

    try {
      final user = FirebaseAuth.instance.currentUser;

      final userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      final amount = ref.watch(paymentAmountProvider);
      final category = ref
          .watch(categoryListProvider.notifier)
          .getSelectedCategoryAndColor()[0] as String;

      //perform transaction
      var userBalance = userData['balance'];
      var receiverBalance = cashSwiftUser.balance;

      if (userBalance > 0 && userBalance > double.parse(amount)) {
        userBalance = userBalance - double.parse(amount);
        receiverBalance = receiverBalance! + double.parse(amount);
        print("Transaction performed");

        // update userBalance and update the payment category balance
        await updateUserBalance(user, userBalance, category, userData, amount);
        //update receiver balance
        final findReceiverData = await FirebaseFirestore.instance
            .collection("users")
            .where("phone", isEqualTo: cashSwiftUser.phoneNumber)
            .get();
        await updateReceiverBalance(
            cashSwiftUser, receiverBalance, findReceiverData);

        final receiverData = findReceiverData.docs.first.data();

        // update user history
        await updateUserHistory(receiverData, userData, amount, category, ref);

        //update receiver history

        await updateReceiverHistory(
            receiverData, userData, amount, category, findReceiverData, ref);

        //fire notification to user and receiver
        NotificationServices.sendNotification(
            userToken: userData['deviceToken'],
            receiverToken: receiverData['deviceToken'],
            userNotificationBody: "₹ $amount sent to ${cashSwiftUser.username}",
            receiverNotificationBody:
                "₹ $amount received from ${userData['username']}");

        // go to next transaction status screen

        ref.watch(transactionStatusProvider.notifier).state = true;
        Navigator.pop(savedContext);
        await showDialog(
          context: savedContext,
          builder: (context) {
            return LoadingRocket();
          },
        );

        final transactionStatus = TransactionStatus(
            status: ref.read(transactionStatusProvider),
            amount: ref.read(paymentAmountProvider),
            receiverName: cashSwiftUser.username,
            receiverPhone: cashSwiftUser.phoneNumber,
            receiverId: cashSwiftUser.id);

        GoRouter.of(savedContext)
            .go("/home/status", extra: {transactionStatus});
      } else {
        // handle insufficient balance error
        Navigator.pop(savedContext);
        ScaffoldMessenger.of(savedContext).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          onVisible: () {
            FocusScope.of(savedContext).unfocus();
          },
          content: Text("Insufficient Balance"),
        ));
      }
    } catch (e) {
      print(
        "Error $e",
      );
      Navigator.of(savedContext).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(savedContext)
          .showSnackBar(SnackBar(content: Text("Some error occured")));
    }
  }

  updateUserBalance(User user, double userBalance, String category, userData,
      String amount) async {
    // add category expense
    final paymentCategory = userData['paymentCategory'] as Map<String, dynamic>;
    paymentCategory.update(category, (value) => value + double.parse(amount));
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "balance": userBalance,
      "paymentCategory": paymentCategory,
      "expenditure": userData['expenditure'] + double.parse(amount)
    });

    print("user balance updated");
  }

  updateReceiverBalance(
      CashSwiftUser cashSwiftUser, double receiverBalance, receiverData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverData.docs.first.id)
        .update({"balance": receiverBalance});

    print("receiver balance updated");
  }

  updateUserHistory(receiverData, userData, String amount, String category,
      WidgetRef ref) async {
    final userHistory = userData['history'];
    final newTransaction = UserHistory(
        username: receiverData['username'],
        phone: receiverData['phone'],
        note: ref.read(noteContentProvider),
        msId: receiverData['msId'],
        amount: "-$amount",
        category: category,
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        date: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year);
    userHistory.insert(0, newTransaction.toJson());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "history": userHistory,
    });

    print("User history updated");
  }

  updateReceiverHistory(receiverData, userData, String amount, String category,
      findReceiverData, WidgetRef ref) async {
    var receiverHistory = receiverData['history'];
    final newTransaction = UserHistory(
        username: userData['username'],
        phone: userData['phone'],
        note: ref.read(noteContentProvider),
        msId: userData['msId'],
        amount: "+$amount",
        category: category,
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        date: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year);
    receiverHistory.insert(0, newTransaction.toJson());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(findReceiverData.docs.first.id)
        .update({"history": receiverHistory});

    print("Receiver history updated");
  }
}
