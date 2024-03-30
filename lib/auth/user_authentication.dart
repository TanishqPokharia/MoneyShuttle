import 'package:cash_swift/notification_services/notification_services.dart';
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
        GoRouter.of(context).go("/home");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User does not exist")));
      } else if (e.code == "wrong-password" && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Incorrect Password")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  static signUpUser(BuildContext context, String email, String password,
      String userName, String phoneNumber, String pin) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      await user!.updateDisplayName(userName);
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "pin": pin,
        "CSid": "${email.split("@").first}@cashswift",
        "balance": 500,
        "Leisure": 0,
        "Entertainment": 0,
        "Grocery": 0,
        "Food": 0,
        "Medicine": 0,
        "Stationary": 0,
        "Travel": 0,
        "Electronics": 0,
        "Bill": 0,
        "Shopping": 0,
        "Others": 0,
        "history": [],
        "deviceToken": ""
      });
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
