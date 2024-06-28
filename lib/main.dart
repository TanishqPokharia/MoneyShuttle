import 'package:cash_swift/firebase_options.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/providers/theme_provider.dart';
import 'package:cash_swift/router/router_config.dart';
import 'package:cash_swift/themes/dark.dart';
import 'package:cash_swift/themes/light.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  runApp(const ProviderScope(child: CashSwiftApp()));
}

class CashSwiftApp extends ConsumerWidget {
  const CashSwiftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'CashSwift',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: ref.watch(themeProvider).maybeWhen(
            data: (data) => data,
            orElse: () => ThemeMode.system,
          ),
    );
  }
}
