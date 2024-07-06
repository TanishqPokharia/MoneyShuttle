import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/models/user_history/user_history.dart';
import 'package:flutter/material.dart';

class TransactionHistory {
  final PaymentCategory paymentCategory;
  final UserHistory userHistory;

  TransactionHistory({
    required this.userHistory,
    required this.paymentCategory,
  });

  Icon get categoryIcon {
    switch (paymentCategory.title) {
      case "Leisure":
        return Icon(Icons.coffee, color: paymentCategory.color);
      case "Entertainment":
        return Icon(Icons.tv, color: paymentCategory.color);
      case "Grocery":
        return Icon(Icons.local_grocery_store, color: paymentCategory.color);
      case "Food":
        return Icon(Icons.lunch_dining, color: paymentCategory.color);
      case "Medicine":
        return Icon(Icons.medication, color: paymentCategory.color);
      case "Stationary":
        return Icon(Icons.book, color: paymentCategory.color);
      case "Travel":
        return Icon(Icons.train, color: paymentCategory.color);
      case "Electronics":
        return Icon(Icons.computer, color: paymentCategory.color);
      case "Bill":
        return Icon(Icons.receipt_long, color: paymentCategory.color);
      case "Shopping":
        return Icon(Icons.shopify, color: paymentCategory.color);
      default:
        return Icon(
          Icons.more_horiz,
          color: paymentCategory.color,
        );
    }
  }
}
