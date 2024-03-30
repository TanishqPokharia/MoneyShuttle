import 'package:cash_swift/models/payment_category.dart';
import 'package:flutter/material.dart';

final List<IndexedPaymentCategory> paymentCategoryList = [
  IndexedPaymentCategory(
      index: 0, title: "Leisure", color: Colors.indigo, isSelected: false),
  IndexedPaymentCategory(
      index: 1, title: "Entertainment", color: Colors.pink, isSelected: false),
  IndexedPaymentCategory(
      index: 2, title: "Grocery", color: Colors.green, isSelected: false),
  IndexedPaymentCategory(
      index: 3, title: "Food", color: Colors.orange, isSelected: false),
  IndexedPaymentCategory(
      index: 4, title: "Medicine", color: Colors.teal, isSelected: false),
  IndexedPaymentCategory(
      index: 5, title: "Stationary", color: Colors.brown, isSelected: false),
  IndexedPaymentCategory(
      index: 6, title: "Travel", color: Colors.deepPurple, isSelected: false),
  IndexedPaymentCategory(
      index: 7, title: "Electronics", color: Colors.blue, isSelected: false),
  IndexedPaymentCategory(
      index: 8,
      title: "Bill",
      color: const Color.fromARGB(255, 218, 198, 21),
      isSelected: false),
  IndexedPaymentCategory(
      index: 9, title: "Shopping", color: Colors.purple, isSelected: false),
  IndexedPaymentCategory(
      index: 10, title: "Other", color: Colors.grey, isSelected: false),
];
