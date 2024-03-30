import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider =
    StreamProvider.family<DocumentSnapshot, User?>((ref, user) {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .snapshots();
});
