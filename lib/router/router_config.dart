import 'package:cash_swift/screens/history/transaction_history_screen.dart';
import 'package:cash_swift/screens/home/home_screen.dart';
import 'package:cash_swift/screens/payment/payment.dart';
import 'package:cash_swift/screens/qr_scan/qr_scan.dart';
import 'package:cash_swift/screens/sign_in/sign_in_screen.dart';
import 'package:cash_swift/screens/sign_up/sign_up_screen.dart';
import 'package:cash_swift/screens/splash/splash_screen.dart';
import 'package:cash_swift/screens/transaction/transaction_screen.dart';
import 'package:cash_swift/screens/transaction_status/transaction_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(initialLocation: "/splash", routes: [
    GoRoute(
      path: "/splash",
      pageBuilder: (context, state) =>
          const MaterialPage(child: SplashScreen()),
    ),
    GoRoute(
      path: "/signUp",
      pageBuilder: (context, state) => MaterialPage(child: SignUpScreen()),
    ),
    GoRoute(
      path: "/signIn",
      pageBuilder: (context, state) => MaterialPage(child: SignInScreen()),
    ),
    GoRoute(
        path: "/home",
        pageBuilder: (context, state) => MaterialPage(child: HomeScreen()),
        routes: [
          GoRoute(
            path: "scan",
            pageBuilder: (context, state) =>
                const MaterialPage(child: QRScanScreen()),
          ),
          GoRoute(
              path: "payment",
              pageBuilder: (context, state) =>
                  MaterialPage(child: PaymentScreen()),
              routes: [
                GoRoute(
                  path: "transaction",
                  pageBuilder: (context, state) {
                    final dynamic payee = state.extra;
                    return MaterialPage(child: TransactionScreen(payee));
                  },
                ),
                GoRoute(
                  path: "status",
                  pageBuilder: (context, state) {
                    final dynamic data = state.extra;
                    return MaterialPage(
                        child: TransactionStatusScreen(
                      transactionStatus: data['status'],
                      amount: data['amount'],
                      receiverName: data['receiverName'],
                      receiverID: data['receiverID'],
                      receiverPhoneNumber: data['receiverPhoneNumber'],
                    ));
                  },
                ),
              ]),
          GoRoute(
            path: "history",
            pageBuilder: (context, state) =>
                MaterialPage(child: TransactionHistoryScreen()),
          )
        ]),
  ]);
}
