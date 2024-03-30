import 'package:cash_swift/models/payment_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryWidget extends ConsumerWidget {
  const CategoryWidget(this.paymentCategory, {super.key});
  final IndexedPaymentCategory paymentCategory;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(mq(context, 10)),
      decoration: BoxDecoration(
          color: paymentCategory.isSelected ? paymentCategory.color : null,
          borderRadius: BorderRadius.circular(mq(context, 10)),
          border: Border.all(color: paymentCategory.color)),
      child: Text(
        paymentCategory.title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: mq(context, 18),
            color: paymentCategory.isSelected
                ? Colors.white
                : paymentCategory.color),
      ),
    );
  }
}
