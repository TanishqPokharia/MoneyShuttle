import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/providers/transaction/category_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryListProvider =
    StateNotifierProvider<CategoryState, List<IndexedPaymentCategory>>((ref) {
  return CategoryState();
});
