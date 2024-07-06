import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
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
    Future.delayed(const Duration(milliseconds: 300), () {
      if (user == null) {
        GoRouter.of(context).go("/signUp");
      } else {
        GoRouter.of(context).go("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: context.backgroundColor, body: Center());
  }
}
