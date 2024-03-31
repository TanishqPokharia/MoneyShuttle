import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cashSwiftIDVerifyProvider =
    StateNotifierProvider<CashSwiftIDNotifier, CashSwiftUser?>((ref) {
  return CashSwiftIDNotifier();
});

class CashSwiftIDNotifier extends StateNotifier<CashSwiftUser?> {
  CashSwiftIDNotifier() : super(null);

  Future<void> verifyCashSwiftID(String cashSwiftID) async {
    print("started");
    final userCollection = FirebaseFirestore.instance.collection("users");
    final queryResult = userCollection.where("CSid", isEqualTo: cashSwiftID);
    final receiver = await queryResult.get();

    if (receiver.docs.isNotEmpty) {
      final receiverData = receiver.docs.first.data();
      state = CashSwiftUser(
          name: receiverData['userName'],
          id: receiverData['CSid'],
          balance: receiverData['balance'],
          phoneNumber: receiverData['phoneNumber']);
      print("receiver data fetched");
    }
  }
}
