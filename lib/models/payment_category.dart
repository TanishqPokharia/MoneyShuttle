import 'package:flutter/material.dart';

class PaymentCategory {
  final String title;
  final Color color;
  static PaymentCategory leisure =
      PaymentCategory(title: "Leisure", color: Colors.indigo);
  static PaymentCategory entertainment =
      PaymentCategory(title: "Entertainment", color: Colors.pink);
  static PaymentCategory grocery =
      PaymentCategory(title: "Grocery", color: Colors.green);
  static PaymentCategory food =
      PaymentCategory(title: "Food", color: Colors.orange);
  static PaymentCategory medicine =
      PaymentCategory(title: "Medicine", color: Colors.teal);
  static PaymentCategory stationary =
      PaymentCategory(title: "Stationary", color: Colors.brown);
  static PaymentCategory travel =
      PaymentCategory(title: "Travel", color: Colors.deepPurple);
  static PaymentCategory electronics =
      PaymentCategory(title: "Electronics", color: Colors.blue);
  static PaymentCategory bill =
      PaymentCategory(title: "Bill", color: Colors.amberAccent);
  static PaymentCategory shopping =
      PaymentCategory(title: "Shopping", color: Colors.purple);
  static PaymentCategory others =
      PaymentCategory(title: "Other", color: Colors.grey);

  static List<PaymentCategory> list = [
    PaymentCategory.leisure,
    PaymentCategory.grocery,
    PaymentCategory.food,
    PaymentCategory.medicine,
    PaymentCategory.stationary,
    PaymentCategory.travel,
    PaymentCategory.electronics,
    PaymentCategory.shopping,
    PaymentCategory.entertainment,
    PaymentCategory.bill,
    PaymentCategory.others
  ];
  static Color getColorByTitle(String title) {
    switch (title.toLowerCase()) {
      case 'leisure':
        return Colors.indigo;
      case 'entertainment':
        return Colors.pink;
      case 'grocery':
        return Colors.green;
      case 'food':
        return Colors.orange;
      case 'medicine':
        return Colors.teal;
      case 'stationary':
        return Colors.brown;
      case 'travel':
        return Colors.deepPurple;
      case 'electronics':
        return Colors.blue;
      case 'bill':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'other':
        return Colors.grey;
      default:
        // Return a default color if the title doesn't match any case
        return Colors.grey.shade900;
    }
  }

  PaymentCategory({required this.title, required this.color});
}

class IndexedPaymentCategory extends PaymentCategory {
  bool isSelected;
  final int index;

  IndexedPaymentCategory({
    required this.index,
    required super.title,
    required super.color,
    required this.isSelected,
  });
}
