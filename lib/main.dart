import 'package:cash_swift/firebase_options.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/router/router_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationServices notificationServices = NotificationServices();
  notificationServices.requestPerms();
  notificationServices.forgroundMessage();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const ProviderScope(child: CashFlowApp()));
}

Color appBackgroundColor = const Color(0xFF272a1f);

class CashFlowApp extends StatelessWidget {
  const CashFlowApp({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'CashSwift',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(centerTitle: true, color: Colors.white),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor:
                    const MaterialStatePropertyAll(Color(0xFF39cd40)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mq(context, 50)))))),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
                elevation: MaterialStatePropertyAll(5),
                alignment: Alignment.center)),
        textTheme: TextTheme(
            titleSmall: GoogleFonts.lato(
                fontSize: mq(context, 18), color: Colors.white),
            titleMedium: GoogleFonts.lato(
                fontSize: mq(context, 26), color: Colors.white),
            titleLarge: GoogleFonts.lato(
                fontSize: mq(context, 36), color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq(context, 5))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq(context, 5))),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq(context, 5))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq(context, 5))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(mq(context, 5)))),
      ),
    );
  }
}
