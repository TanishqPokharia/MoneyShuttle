import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/widgets/pie_chart_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTypes extends ConsumerWidget {
  const CategoryTypes(
      {super.key, required this.paymentCategory, required this.expenditure});
  final Map<String, dynamic> paymentCategory;
  final double expenditure;

  String getExpenditurePercentage(double categorySpend, double expenditure) {
    return "${(((categorySpend) / expenditure) * 100).toStringAsFixed(2)}%";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.rSize(20)),
      padding: EdgeInsets.symmetric(
          vertical: context.rSize(20), horizontal: context.rSize(5)),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(context.rSize(10))),
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 2,
        children: [
          ...PaymentCategory.list.map((e) => Indicator(
              paymentCategory: e,
              percentage: getExpenditurePercentage(
                  paymentCategory[e.title]!.toDouble(), expenditure)))
        ],
      ),
    );
  }
}
