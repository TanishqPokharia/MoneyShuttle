import 'package:cash_swift/screens/balance/balance_screen.dart';
import 'package:cash_swift/screens/chat/chat_list_screen.dart';
import 'package:cash_swift/screens/chat/chat_screen.dart';
import 'package:cash_swift/screens/custom_qr/custom_qr_screen.dart';
import 'package:cash_swift/screens/history/transaction_history_screen.dart';
import 'package:cash_swift/screens/home/home_screen.dart';
import 'package:cash_swift/screens/payment/payment.dart';
import 'package:cash_swift/screens/profile/profile_screen.dart';
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
        pageBuilder: (context, state) => MaterialPage(child: SplashScreen())),
    GoRoute(
      path: "/signUp",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            child: child,
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeIn))
                .animate(animation),
          );
        },
      ),
    ),
    GoRoute(
      path: "/signIn",
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: SignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
              child: child,
              position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeIn))
                  .animate(animation));
        },
      ),
    ),
    GoRoute(
        path: "/home",
        pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: Duration(seconds: 1, milliseconds: 500),
            key: state.pageKey,
            child: HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation,
                    child) =>
                Align(
                  child: SizeTransition(
                    sizeFactor: Tween<double>(begin: 0, end: 1)
                        .chain(
                            CurveTween(curve: Curves.fastEaseInToSlowEaseOut))
                        .animate(animation),
                    axisAlignment: -1,
                    child: child,
                  ),
                )),
        routes: [
          GoRoute(
            path: "profile",
            pageBuilder: (context, state) =>
                MaterialPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: "balance/:balance",
            pageBuilder: (context, state) {
              dynamic data = state.extra;
              final String? balance = state.pathParameters['balance'];
              return MaterialPage(
                  child: BalanceScreen(
                      transactionHistoryList: data, balance: balance));
            },
          ),
          GoRoute(
              path: "chatlist",
              pageBuilder: (context, state) {
                final msIdUser = state.extra as String;
                return MaterialPage(child: ChatListScreen(msIdUser));
              },
              routes: [
                GoRoute(
                  path: "chat",
                  pageBuilder: (context, state) {
                    final ids = state.extra as Map<String, dynamic>;
                    return MaterialPage(
                        child: ChatScreen(
                      msIdUser: ids['msIdUser'],
                      chatData: ids['chatData'],
                    ));
                  },
                ),
              ]),
          GoRoute(
            path: "customQR",
            pageBuilder: (context, state) => CustomTransitionPage(
              child: CustomQRScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                child: child,
                position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.fastOutSlowIn))
                    .animate(animation),
              ),
            ),
          ),
          GoRoute(
            path: "status",
            pageBuilder: (context, state) {
              final dynamic data = state.extra;
              return MaterialPage(
                  child: TransactionStatusScreen(transactionStatus: data));
            },
          ),
          GoRoute(
            path: "transaction",
            pageBuilder: (context, state) {
              final dynamic payee = state.extra;
              final String? amount = state.uri.queryParameters['amount'];
              return MaterialPage(
                  child: TransactionScreen(payee, amount ?? null));
            },
          ),
          GoRoute(
              path: "scan",
              pageBuilder: (context, state) =>
                  const MaterialPage(child: QRScanScreen()),
              routes: [
                GoRoute(
                    path: "transaction",
                    pageBuilder: (context, state) {
                      final dynamic payee = state.extra;
                      final String amount =
                          state.uri.queryParameters['amount'] as String;
                      return MaterialPage(
                          child: TransactionScreen(payee, amount));
                    },
                    routes: []),
              ]),
          GoRoute(
              path: "payment",
              pageBuilder: (context, state) => CustomTransitionPage(
                    child: PaymentScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        child: child,
                        position:
                            Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.fastOutSlowIn))
                                .animate(animation),
                      );
                    },
                  ),
              routes: [
                GoRoute(
                    path: "transaction",
                    pageBuilder: (context, state) {
                      final dynamic payee = state.extra;
                      final String? amount =
                          state.uri.queryParameters['amount'];
                      return MaterialPage(
                          child: TransactionScreen(payee, amount));
                    },
                    routes: []),
              ]),
          GoRoute(
            path: "history",
            pageBuilder: (context, state) => CustomTransitionPage(
              child: TransactionHistoryScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position:
                      Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.fastOutSlowIn))
                          .animate(animation),
                  child: child,
                );
              },
            ),
          )
        ]),
  ]);
}
