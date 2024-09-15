import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = FutureProvider<DocumentSnapshot>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
});
