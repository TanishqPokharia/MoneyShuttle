import 'package:cash_swift/providers/transaction/category_list_provider.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/transaction_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionCleanUpProvider =
    StateNotifierProvider<TransactionCleanUpNotifier, void>((ref) {
  return TransactionCleanUpNotifier();
});

class TransactionCleanUpNotifier extends StateNotifier<void> {
  TransactionCleanUpNotifier() : super(());

  void cleanUpTransactionData(WidgetRef ref) {
    ref.read(noteContentProvider.notifier).state = "";
    ref.read(transactionStatusProvider.notifier).state = false;
    ref.read(categoryListProvider.notifier).resetCategories();
  }
}
