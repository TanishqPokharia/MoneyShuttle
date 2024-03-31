import 'package:cash_swift/data/payment_category_list.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryState extends StateNotifier<List<IndexedPaymentCategory>> {
  CategoryState() : super(paymentCategoryList);

  void selectCategory(int index) {
    state.forEach((element) {
      element.isSelected = false;
    });

    state.elementAt(index).isSelected = true;

    state = [...state];
  }

  List<Object> getSelectedCategoryAndColor() {
    final iterable = state.where((element) => element.isSelected);
    return [iterable.first.title, iterable.first.color];
  }

  void resetCategories() {
    state.forEach((element) {
      element.isSelected = false;
    });
    state = [...state];
  }
}
