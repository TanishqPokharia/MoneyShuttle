import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/providers/transaction/category_list_provider.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/note_provider.dart';
import 'package:cash_swift/providers/transaction/transaction_notifier.dart';
import 'package:cash_swift/widgets/category_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionScreen extends ConsumerWidget {
  TransactionScreen(this.cashSwiftUser, this.amountToPay, {super.key});

  final CashSwiftUser cashSwiftUser;
  final String? amountToPay;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction",
          style: context.textLarge,
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            color: context.backgroundColor,
            width: context.screenWidth,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(context.rSize(20)),
                    child: Text(
                      "Sending payment to:\n${cashSwiftUser.username}",
                      textAlign: TextAlign.center,
                      style: context.textMedium,
                    ),
                  ),
                  Text("+91 ${cashSwiftUser.phoneNumber!}",
                      style: context.textMedium),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: context.rSize(150),
                        vertical: context.rSize(40)),
                    child: TextFormField(
                      initialValue: amountToPay,
                      validator: (value) {
                        if (value == "0" || int.tryParse(value!) == null) {
                          return "Invalid Amount";
                        }
                        try {
                          int.parse(value);
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
                          hintText: "   0",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue)),
                          enabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          errorBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          prefixIcon: Icon(
                            Icons.currency_rupee_sharp,
                          )),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: ref.watch(noteProvider) ? 1 : 0,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        height:
                            ref.watch(noteProvider) ? context.rSize(120) : 0,
                        margin:
                            EdgeInsets.symmetric(horizontal: context.rSize(20)),
                        child: TextFormField(
                            onSaved: (newValue) {
                              ref.watch(noteContentProvider.notifier).state =
                                  newValue!;
                            },
                            maxLength: 35,
                            style: context.textMedium,
                            decoration: InputDecoration(
                                counterStyle: context.textSmall!
                                    .copyWith(fontSize: context.rSize(16)),
                                hintText: "Add a note...",
                                hintStyle: TextStyle(color: Colors.grey)))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: context.rSize(100),
                        vertical: context.rSize(30)),
                    height: context.rSize(80),
                    width: ref.watch(noteStatusProvider)
                        ? context.rSize(220)
                        : context.rSize(200),
                    child: FittedBox(
                      child: TextButton(
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
                                style: context.textSmall!
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(
                                width: context.rSize(10),
                              ),
                              Icon(
                                ref.watch(noteStatusProvider)
                                    ? Icons.delete
                                    : Icons.note_add,
                              )
                            ],
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(context.rSize(20)),
                    child: Wrap(
                      spacing: context.rSize(10),
                      runSpacing: context.rSize(20),
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
                    margin: EdgeInsets.all(
                      context.rSize(20),
                    ),
                    padding: EdgeInsets.only(bottom: context.rSize(50)),
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final user = FirebaseAuth.instance.currentUser;
                            final data = await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user!.uid)
                                .get();
                            final pin = data['pin'];
                            if (context.mounted) {
                              await ref
                                  .read(transactionNotifierProvider.notifier)
                                  .validatePin(
                                      context, ref, pin, cashSwiftUser);
                            }
                          }
                        },
                        child: Text("Pay")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
