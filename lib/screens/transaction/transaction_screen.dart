import 'package:cash_swift/main.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/providers/transaction/category_list_provider.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/note_provider.dart';
import 'package:cash_swift/providers/transaction/transaction_loading_provider.dart';
import 'package:cash_swift/widgets/category_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class TransactionScreen extends ConsumerWidget {
  TransactionScreen(this.cashSwiftUser, {super.key});

  final CashSwiftUser cashSwiftUser;
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData =
        ref.watch(userDataProvider(FirebaseAuth.instance.currentUser));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Transaction",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: appBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              color: appBackgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(mq(context, 20)),
                      child: Text(
                        "Sending payment to:\n${cashSwiftUser.name}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(cashSwiftUser.phoneNumber!,
                        style: Theme.of(context).textTheme.titleMedium),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 150),
                          vertical: mq(context, 40)),
                      child: TextFormField(
                        validator: (value) {
                          if (value == "0") {
                            return "Invalid Amount";
                          }
                          try {
                            double.parse(value!);
                          } catch (error) {
                            return "Enter valid amount";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          ref.read(paymentAmountProvider.notifier).state =
                              newValue!;
                        },
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration: const InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlue)),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlue)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              Icons.currency_rupee_sharp,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    ref.watch(noteProvider)
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: mq(context, 20)),
                            child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please provide a proper note";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  ref
                                      .watch(noteContentProvider.notifier)
                                      .state = newValue!;
                                },
                                style: Theme.of(context).textTheme.titleMedium,
                                decoration: const InputDecoration(
                                    hintText: "Add a note...",
                                    hintStyle: TextStyle(color: Colors.grey))),
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 100),
                          vertical: mq(context, 30)),
                      height: mq(context, 80),
                      width: ref.watch(noteStatusProvider)
                          ? mq(context, 220)
                          : mq(context, 200),
                      child: FittedBox(
                        child: TextButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue)),
                            onPressed: () {
                              ref.read(noteProvider.notifier).state =
                                  !ref.read(noteProvider.notifier).state;

                              ref.read(noteStatusProvider.notifier).state =
                                  !ref.read(noteStatusProvider.notifier).state;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  ref.watch(noteStatusProvider)
                                      ? "Remove Note"
                                      : "Add Note",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Icon(
                                  ref.watch(noteStatusProvider)
                                      ? Icons.delete
                                      : Icons.note_add,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 20)),
                      child: Wrap(
                        spacing: mq(context, 10),
                        runSpacing: mq(context, 20),
                        children: ref
                            .watch(categoryListProvider)
                            .map((paymentCategory) => GestureDetector(
                                onTap: () {
                                  ref
                                      .read(categoryListProvider.notifier)
                                      .selectCategory(paymentCategory.index);
                                },
                                child: CategoryWidget(paymentCategory)))
                            .toList(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 20)),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.all(mq(context, 10))),
                            elevation: const MaterialStatePropertyAll(0),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 21, 122, 204)),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              print("Hello");

                              final user = FirebaseAuth.instance.currentUser;
                              final data = await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user!.uid)
                                  .get();
                              final pin = data['pin'];
                              if (context.mounted) {
                                await validatePin(context, ref, pin);
                              }
                            }
                          },
                          child: Text(
                            "Pay",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  initiateTransaction(context) {
    print("Hello");
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
              height: mq(context, 100),
              child: SizedBox(
                height: mq(context, 100),
                width: mq(context, 100),
                child: CircularProgressIndicator(),
              )),
        );
      },
    );
  }

  Future<void> validatePin(
      BuildContext context, WidgetRef ref, String pin) async {
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
            height: mq(context, 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter PIN",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ),
                Container(
                  height: 100,
                  child: Pinput(
                    keyboardType: TextInputType.phone,
                    cursor: Container(
                      color: Colors.black,
                      width: mq(context, 3),
                      height: mq(context, 30),
                    ),
                    isCursorAnimationEnabled: true,
                    showCursor: true,
                    obscureText: true,
                    obscuringWidget: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      width: mq(context, 15),
                      height: mq(context, 15),
                    ),
                    validator: (value) {
                      return value == pin ? null : "Wrong PIN";
                    },
                    errorBuilder: (errorText, pin) {
                      return Container(
                        margin: EdgeInsets.all(mq(context, 10)),
                        child: Text(errorText!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.red)),
                      );
                    },
                    autofocus: true,
                    onCompleted: (value) async {
                      if (value == pin) {
                        Navigator.pop(context);

                        ref
                            .read(categoryListProvider.notifier)
                            .isAnyCategorySelected();

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

                          if (userBalance > 0 &&
                              userBalance > amount) {
                            userBalance = userBalance - double.parse(amount);
                            receiverBalance =
                                receiverBalance! + double.parse(amount);
                            print("Transaction performed");

                            //update userBalance and update the payment category balance
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user.uid)
                                .update({
                              "balance": userBalance,
                              category:
                                  userData[category] + double.parse(amount),
                              "expenditure":
                                  userData['expenditure'] + double.parse(amount)
                            });

                            print("user balance updated");

                            //update receiver balance
                            final findReceiverData = await FirebaseFirestore
                                .instance
                                .collection("users")
                                .where("phoneNumber",
                                    isEqualTo: cashSwiftUser.phoneNumber)
                                .get();

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(findReceiverData.docs.first.id)
                                .update({"balance": receiverBalance});

                            print("receiver balance updated");

                            // update user history
                            final userHistory = userData['history'];
                            userHistory.insert(0, {
                              "name": cashSwiftUser.name,
                              "balance": cashSwiftUser.balance,
                              "phoneNumber": cashSwiftUser.phoneNumber,
                              "CSid": cashSwiftUser.id,
                              "note": ref.read(noteContentProvider),
                              "amount": "-$amount",
                              "category": category,
                              "time":
                                  "${DateTime.now().hour}:${DateTime.now().minute}",
                              "date": DateTime.now().day,
                              "month": DateTime.now().month,
                              "year": DateTime.now().year
                            });
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              "history": userHistory,
                            });

                            print("User history updated");

                            //update receiver history

                            final receiverData =
                                findReceiverData.docs.first.data();
                            var receiverHistory = receiverData['history'];
                            receiverHistory.insert(0, {
                              "name": userData['userName'],
                              "phoneNumber": userData['phoneNumber'],
                              "note": ref.read(noteContentProvider),
                              "CSid": userData['CSid'],
                              "amount": "+$amount",
                              "balance": userData['balance'],
                              "category": category,
                              "time":
                                  "${DateTime.now().hour}:${DateTime.now().minute}",
                              "date": DateTime.now().day,
                              "month": DateTime.now().month,
                              "year": DateTime.now().year
                            });

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(findReceiverData.docs.first.id)
                                .update({"history": receiverHistory});

                            print("Receiver history updated");

                            //fire notification to user and receiver
                            NotificationServices.sendNotification(
                                userToken: userData['deviceToken'],
                                receiverToken: receiverData['deviceToken'],
                                userNotificationBody:
                                    "₹ $amount sent to ${cashSwiftUser.name}",
                                receiverNotificationBody:
                                    "₹ $amount received from ${userData['userName']}");
                            ref
                                .watch(transactionStatusProvider.notifier)
                                .state = true;
                            Navigator.pop(savedContext);
                            GoRouter.of(savedContext)
                                .go("/home/status", extra: {
                              "status": ref.watch(transactionStatusProvider),
                              "amount": ref.watch(paymentAmountProvider),
                              "receiverName": cashSwiftUser.name,
                              "receiverPhoneNumber": cashSwiftUser.phoneNumber,
                              "receiverID": cashSwiftUser.id
                            });
                          } else {
                            Navigator.pop(savedContext);
                            ScaffoldMessenger.of(savedContext).showSnackBar(SnackBar(
                              content: Text("Insufficient Balance"),
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        } on Exception catch (e) {
                          // TODO
                          print(e);
                        } catch (e) {
                          print(e);
                        }
                        print("Yay");
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: mq(context, 120),
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
}
