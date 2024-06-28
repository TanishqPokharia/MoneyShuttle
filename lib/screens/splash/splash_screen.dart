import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/main.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.initFirebase(context);
    Future.delayed(const Duration(seconds: 3), () {
      if (user == null) {
        GoRouter.of(context).go("/signUp");
      } else {
        GoRouter.of(context).go("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: appBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset(
              "assets/logo.png",
              height: context.rSize(300),
            ),
          )),
    );
  }
}
