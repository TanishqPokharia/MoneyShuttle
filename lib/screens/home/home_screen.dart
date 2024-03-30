import 'package:cash_swift/main.dart';
import 'package:cash_swift/providers/home/check_balance_provider.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final user = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(user));
    return Scaffold(
      body: Container(
        color: appBackgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            stretch: true,
            stretchTriggerOffset: mq(context, 300),
            title: Text("CashSwift"),
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    child: Container(
                      width: mq(context, 300),
                      child: Text(
                        "Hi,\n${user!.displayName!.split(" ").first} \t👋🏻",
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  ProfilePhoto(
                      name: user!.displayName!,
                      nameDisplayOption: NameDisplayOptions.initials,
                      totalWidth: mq(context, 100),
                      cornerRadius: mq(context, 100),
                      color: Colors.green,
                      fontColor: Colors.white)
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: mq(context, 50),
                    bottom: mq(context, 10),
                    left: mq(context, 10),
                    right: mq(context, 10)),
                child: Material(
                  type: MaterialType.card,
                  elevation: 10,
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(mq(context, 20)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(mq(context, 10)),
                        gradient: const LinearGradient(
                            colors: [
                              Colors.indigo,
                              Colors.deepPurple,
                              Colors.deepPurpleAccent
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    width: double.infinity,
                    height: mq(context, 250),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "CashSwift",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Image.asset(
                              "assets/chip.png",
                              alignment: Alignment.centerLeft,
                              width: mq(context, 100),
                              height: mq(context, 80),
                            ),
                            userData.when(
                              loading: () => Text(
                                "Loading...",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              data: (snapshot) {
                                var userInfo = snapshot.data() as Map;
                                return Container(
                                  child: Text(
                                    userInfo['CSid'],
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                );
                              },
                              error: (error, stackTrace) => Text(
                                "Error",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            userData.when(
                              loading: () => Text(
                                "Loading...",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              data: (data) => Container(
                                width: mq(context, 250),
                                child: Text(
                                  data['userName'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              error: (error, stackTrace) => Text(
                                "Error",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            userData.when(
                              loading: () => SizedBox(
                                  height: mq(context, 150),
                                  width: mq(context, 150),
                                  child: CircularProgressIndicator()),
                              data: (data) => SizedBox(
                                  height: mq(context, 150),
                                  width: mq(context, 150),
                                  child: QrImageView(
                                    eyeStyle: const QrEyeStyle(
                                        color: Colors.white,
                                        eyeShape: QrEyeShape.square),
                                    dataModuleStyle: const QrDataModuleStyle(
                                        color: Colors.white,
                                        dataModuleShape:
                                            QrDataModuleShape.square),
                                    data: data['CSid'],
                                  )),
                              error: (error, stackTrace) => SizedBox(
                                  height: mq(context, 150),
                                  width: mq(context, 150),
                                  child: Text(
                                    "Error loading QR",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  )),
                            ),
                            Container(
                              child: Text(
                                "QR Code",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    transactionHistoryCard(context),
                    makePaymentCard(context)
                  ],
                ),
              ),
              Container(
                height: mq(context, 100),
                margin: EdgeInsets.symmetric(horizontal: mq(context, 25)),
                child: InkWell(
                  onTap: () {
                    try {
                      userData.whenData(
                        (value) =>
                            askPinToCheckBalance(context, ref, value['pin']),
                      );
                    } on Exception catch (_) {
                      // TODO
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Unable to fetch balance")));
                    }
                  },
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Check Account Balance",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: mq(context, 40),
                        ),
                        userData.when(
                          loading: () => Text(
                            "Fetching...",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          data: (data) => AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOutSine,
                            opacity: ref.watch(checkBalanceProvider) ? 1 : 0,
                            child: GestureDetector(
                              onTap: () {
                                ref.read(checkBalanceProvider.notifier).state =
                                    !ref
                                        .read(checkBalanceProvider.notifier)
                                        .state;
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.currency_rupee_sharp,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    data['balance'].toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          error: (error, stackTrace) => Text(
                            "Error",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                child: Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 20)),
                child: TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.indigo)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      GoRouter.of(context).go("/signUp");
                    },
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              )
            ]),
          )
        ]),
      ),
    );
  }

  askPinToCheckBalance(BuildContext context, WidgetRef ref, String pin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          elevation: 5,
          insetAnimationDuration: Duration(milliseconds: 300),
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
                  width: mq(context, 120),
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

  Widget transactionHistoryCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(mq(context, 10)),
      padding: EdgeInsets.all(mq(context, 10)),
      height: mq(context, 200),
      width: mq(context, 250),
      child: Card(
        color: Colors.indigo,
        child: InkWell(
          onTap: () {
            GoRouter.of(context).go("/home/history");
          },
          splashColor: Colors.indigoAccent,
          highlightColor: Colors.indigoAccent,
          borderRadius: BorderRadius.circular(mq(context, 10)),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Opacity(
                opacity: 0.7,
                child: Image.asset("assets/history_cards.png"),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(mq(context, 10)),
                width: mq(context, 200),
                child: Text(
                  "View\nTransactions",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(mq(context, 10)),
                  child: Icon(
                    Icons.history,
                    size: mq(context, 50),
                    color: Colors.white.withOpacity(0.8),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget makePaymentCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(mq(context, 10)),
      padding: EdgeInsets.all(mq(context, 10)),
      height: mq(context, 200),
      width: mq(context, 250),
      child: Card(
        color: Colors.green,
        child: InkWell(
          onTap: () {
            showPaymentOptions(context);
          },
          splashColor: Colors.greenAccent,
          highlightColor: Colors.greenAccent,
          borderRadius: BorderRadius.circular(mq(context, 10)),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Opacity(
                opacity: 0.7,
                child: Image.asset("assets/pay.png", width: 200),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(mq(context, 10)),
                width: mq(context, 200),
                child: Text(
                  "Pay",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(mq(context, 10)),
                  child: Icon(
                    Icons.currency_rupee_sharp,
                    size: mq(context, 50),
                    color: Colors.white.withOpacity(0.8),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showPaymentOptions(context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      barrierColor: Colors.black.withOpacity(0.5),
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: mq(context, mq(context, 500)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Phone Number",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Scan QR",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 20)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Duration(seconds: 1);
                      searchCashSwiftID(context);
                    },
                    child: Text(
                      "CashSwift ID",
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  void searchCashSwiftID(context) {
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
            height: mq(context, 650),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: TextFormField(
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                      decoration: InputDecoration(label: Text("CashSwift ID")),
                    )),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: mq(context, 20)),
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Make Payment",
                          style: Theme.of(context).textTheme.titleMedium,
                        )))
              ],
            ),
          ),
        );
      },
    );
  }
}
