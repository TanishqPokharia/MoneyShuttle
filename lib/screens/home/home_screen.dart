import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/models/user_history/user_history.dart';
import 'package:cash_swift/providers/home/cash_swift_id_provider.dart';
import 'package:cash_swift/providers/home/cash_swift_id_verification_provider.dart';
import 'package:cash_swift/providers/home/check_balance_provider.dart';
import 'package:cash_swift/providers/home/transaction_cleanup_notifier.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/providers/history/pieCharHoldedProvider.dart';
import 'package:cash_swift/screens/home/home_screen_loading.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/widgets/drawer.dart';
import 'package:cash_swift/widgets/feature_card.dart';
import 'package:cash_swift/widgets/recent_transaction.dart';
import 'package:cash_swift/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: AppDrawer(username: user!.displayName!),
      appBar: AppBar(
          title: Text("Home"),
          leading: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(left: context.rSize(10)),
              child: ProfilePhoto(
                name: user!.displayName!,
                nameDisplayOption: NameDisplayOptions.initials,
                outlineColor: Colors.white,
                outlineWidth: 2,
                totalWidth: context.rSize(50),
                cornerRadius: context.rSize(100),
                color: Colors.green,
                fontColor: Colors.white,
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          })),
      body: Container(
        color: appBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: ref.watch(userDataProvider).when(
              loading: () => HomeScreenLoading(),
              error: (error, stackTrace) {
                print(error);
                print(stackTrace);
                return Center(
                  child: Text(
                    "Oops! Looks like we ran into a problem",
                    style: context.textMedium,
                  ),
                );
              },
              data: (data) {
                final UserData userDetails =
                    UserData.fromJson(data.data() as Map<String, dynamic>);
                print(userDetails.toString());
                return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserMoneyShuttleCard(
                          msId: userDetails.msId,
                          username: userDetails.username,
                          onPressQR: () {
                            expandQR(context, userDetails.msId);
                          },
                        ),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FeatureCard(
                                  title: "View\nTransactions",
                                  icon: Icons.history,
                                  color: Colors.indigo,
                                  splashColor: Colors.indigoAccent,
                                  image:
                                      Image.asset("assets/history_cards.png"),
                                  onTap: () async {
                                    ref.refresh(userDataProvider.future);
                                    ref
                                        .read(pieCharHoldedProvider.notifier)
                                        .state = false;
                                    GoRouter.of(context).go("/home/history");
                                  }),
                              FeatureCard(
                                  title: "Pay",
                                  icon: Icons.currency_rupee_sharp,
                                  color: Colors.green,
                                  splashColor: Colors.greenAccent,
                                  image: Image.asset("assets/pay.png"),
                                  onTap: () {
                                    ref
                                        .read(
                                            transactionCleanUpProvider.notifier)
                                        .cleanUpTransactionData(ref);
                                    showPaymentOptions(context, ref);
                                  })
                            ],
                          ),
                        ),
                        // Container(
                        //     height: context.rSize(100),
                        //     margin: EdgeInsets.symmetric(
                        //         horizontal: context.rSize(25)),
                        //     child: InkWell(
                        //       onTap: () {
                        //         try {
                        //           ref
                        //               .read(homeNotifierProvider.notifier)
                        //               .askPinToCheckBalance(
                        //                   context, ref, userDetails.pin);
                        //         } on Exception catch (_) {
                        //           // TODO
                        //           ScaffoldMessenger.of(context)
                        //               .showSnackBar(const SnackBar(
                        //                   content: Text(
                        //                       "Unable to fetch balance")));
                        //         }
                        //       },
                        //       child: FittedBox(
                        //           child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.start,
                        //               children: [
                        //             Text(
                        //               "Check Account Balance",
                        //               style: context.textMedium,
                        //             ),
                        //             Icon(
                        //               Icons.arrow_right,
                        //               color: Colors.white,
                        //               size: context.rSize(40),
                        //             ),
                        //             AnimatedOpacity(
                        //               duration: const Duration(seconds: 1),
                        //               curve: Curves.easeOutSine,
                        //               opacity:
                        //                   ref.watch(checkBalanceProvider)
                        //                       ? 1
                        //                       : 0,
                        //               child: Row(
                        //                 children: [
                        //                   const Icon(
                        //                     Icons.currency_rupee_sharp,
                        //                     color: Colors.white,
                        //                   ),
                        //                   Text(
                        //                     userDetails.balance.toString(),
                        //                     style: context.textMedium,
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ])),
                        //     )),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: context.rSize(20),
                              vertical: context.rSize(30)),
                          child: Text(
                            "Recent Transactions",
                            style: context.textLarge,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: context.rSize(30)),
                            child: Builder(
                              builder: (context) {
                                final history = userDetails.history;
                                final Set<String> unqiueUsers = {};
                                if (history.isNotEmpty) {
                                  return Wrap(
                                      spacing: context.rSize(10),
                                      runSpacing: context.rSize(10),
                                      children: [
                                        ...history
                                            .take(20)
                                            .where((element) => unqiueUsers
                                                .add(element['msId']))
                                            .map((e) {
                                          final userHistory =
                                              UserHistory.fromJson(e);
                                          return RecentTransaction(
                                              userHistory: userHistory);
                                        }),
                                      ]);
                                } else {
                                  return Container(
                                    margin: EdgeInsets.all(context.rSize(20)),
                                    child: Text(
                                      "No past transactions",
                                      style: context.textMedium,
                                    ),
                                  );
                                }
                              },
                            ))
                      ]),
                );
              },
            ),
      ),
    );
  }

  void expandQR(BuildContext context, qrData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appBackgroundColor,
      showDragHandle: true,
      builder: (context) {
        return Container(
            padding: EdgeInsets.all(context.rSize(10)),
            height: context.rSize(600),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                QrImageView(
                  size: context.rSize(300),
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                      color: Colors.black, eyeShape: QrEyeShape.square),
                  dataModuleStyle: const QrDataModuleStyle(
                      color: Colors.black,
                      dataModuleShape: QrDataModuleShape.square),
                  data: qrData,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: context.rSize(30),
                      left: context.rSize(20),
                      right: context.rSize(20)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        GoRouter.of(context).push("/home/customQR");
                      },
                      child: Text(
                        "Generate Custom QR",
                        style: context.textMedium,
                      )),
                )
              ],
            ));
      },
    );
  }

  void askPinToCheckBalance(BuildContext context, WidgetRef ref, String pin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          backgroundColor: appBackgroundColor,
          elevation: 5,
          insetAnimationDuration: Duration(milliseconds: 300),
          insetAnimationCurve: Curves.easeIn,
          child: SizedBox(
            height: context.rSize(300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter PIN",
                  style: context.textMedium,
                ),
                Container(
                  height: 100,
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
                    onCompleted: (value) {
                      if (value == pin) {
                        ref.read(checkBalanceProvider.notifier).state =
                            !ref.read(checkBalanceProvider.notifier).state;
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: context.rSize(120),
                  child: TextButton(
                      onPressed: () {
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

  void searchCashSwiftID(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      builder: (context) {
        return Form(
          key: formKey,
          child: Container(
            width: double.infinity,
            height: context.rSize(650),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(context.rSize(20)),
                    child: TextFormField(
                      style: context.textMedium!.copyWith(color: Colors.black),
                      decoration: InputDecoration(label: Text("CashSwift ID")),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@cashswift")) {
                          return "Invalid CashSwift ID";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        ref.read(cashSwiftIDProvider.notifier).state =
                            newValue!;
                      },
                    )),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                        horizontal: context.rSize(20),
                        vertical: context.rSize(20)),
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await ref
                                .read(cashSwiftIDVerifyProvider.notifier)
                                .verifyCashSwiftID(
                                    ref.read(cashSwiftIDProvider), context);
                            print(ref.read(cashSwiftIDProvider));
                            if (context.mounted) {
                              if (ref.read(cashSwiftIDVerifyProvider) != null) {
                                Navigator.pop(context);
                                const Duration(milliseconds: 500);
                                ref
                                    .read(transactionCleanUpProvider.notifier)
                                    .cleanUpTransactionData(ref);
                                GoRouter.of(context).go("/home/transaction",
                                    extra: ref.read(cashSwiftIDVerifyProvider));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text("This CashSwift ID does not exist"),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            }
                          }
                        },
                        child: Text(
                          "Make Payment",
                          style: context.textMedium,
                        )))
              ],
            ),
          ),
        );
      },
    );
  }

  void showPaymentOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: Colors.blueGrey.shade900,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: context.rSize(350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: context.rSize(20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      const Duration(seconds: 1);
                      GoRouter.of(context).go("/home/payment");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone_android,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: context.rSize(10),
                        ),
                        Text(
                          "Phone Number",
                          style: context.textMedium,
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: context.rSize(20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      const Duration(seconds: 1);
                      GoRouter.of(context).go("/home/scan");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: context.rSize(10),
                        ),
                        Text(
                          "Scan QR",
                          style: context.textMedium,
                        ),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: context.rSize(20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      const Duration(seconds: 1);
                      searchCashSwiftID(context, ref);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.perm_identity,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: context.rSize(10),
                        ),
                        Text(
                          "CashSwift ID",
                          style: context.textMedium,
                        ),
                      ],
                    )),
              )
            ],
          ),
        );
      },
    );
  }
}
