import 'package:cash_swift/models/payment_category.dart';

class Payment {
  final String title;
  final double amount;
  final IndexedPaymentCategory paymentCategory;

  Payment(
      {required this.title,
      required this.amount,
      required this.paymentCategory});
}
