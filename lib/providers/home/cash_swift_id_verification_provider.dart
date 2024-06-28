import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cashSwiftIDVerifyProvider =
    StateNotifierProvider<CashSwiftIDNotifier, CashSwiftUser?>((ref) {
  return CashSwiftIDNotifier();
});

class CashSwiftIDNotifier extends StateNotifier<CashSwiftUser?> {
  CashSwiftIDNotifier() : super(null);

  Future<void> verifyCashSwiftID(
      String cashSwiftID, BuildContext context) async {
    print("started");
    final userCollection = FirebaseFirestore.instance.collection("users");
    final queryResult = userCollection.where("msId", isEqualTo: cashSwiftID);
    final receiver = await queryResult.get();

    if (receiver.docs.isNotEmpty) {
      final receiverData = receiver.docs.first.data();
      state = CashSwiftUser(
          email: null,
          username: receiverData['username'],
          id: receiverData['msId'],
          balance: receiverData['balance'].toDouble(),
          phoneNumber: receiverData['phone']);
      print("receiver data fetched");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error scanning code")));
    }
  }
}
