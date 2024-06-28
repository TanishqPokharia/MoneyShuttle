import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/notification_services/notification_services.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserAuthentication {
  static signInUser(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      print(user!.displayName);
      if (context.mounted) {
        NotificationServices notificationServices = NotificationServices();

        notificationServices.forgroundMessage();
        notificationServices.initFirebase(context);
        notificationServices.getDeviceToken().then((value) async {
          print(value);
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .update({"deviceToken": value});
        });
      }
      if (context.mounted) {
        Navigator.pop(context);
        GoRouter.of(context).go("/home");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" && context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User does not exist")));
      } else if (e.code == "wrong-password" && context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Incorrect Password")));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  static signUpUser(BuildContext context, CashSwiftUser cashSwiftUser,
      String password, String pin) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: cashSwiftUser.email!, password: password);
      final user = FirebaseAuth.instance.currentUser;
      await user!.updateDisplayName(cashSwiftUser.username);
      final Map<String, double> paymentCategory = {};
      PaymentCategory.list.forEach((element) {
        paymentCategory[element.title] = 0;
      });
      final UserData userData = UserData(
          username: cashSwiftUser.username,
          email: cashSwiftUser.email!,
          phone: cashSwiftUser.phoneNumber!,
          pin: pin,
          msId: "${cashSwiftUser.email!.split("@").first}@MS",
          balance: 500,
          expenditure: 0,
          paymentCategory: paymentCategory,
          history: [],
          deviceToken: "");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(userData.toJson());

      if (context.mounted) {
        NotificationServices notificationServices = NotificationServices();

        notificationServices.forgroundMessage();
        notificationServices.initFirebase(context);
        notificationServices.getDeviceToken().then((value) async {
          print(value);
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({"deviceToken": value});
        });
      }

      if (context.mounted) {
        Navigator.pop(context);
        GoRouter.of(context).go("/home");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password" && context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password is too weak")));
      } else if (e.code == "email-already-in-use" && context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email already exists")));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
