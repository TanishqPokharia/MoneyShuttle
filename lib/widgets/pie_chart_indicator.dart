import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/providers/history/pieCharHoldedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Indicator extends ConsumerWidget {
  final PaymentCategory paymentCategory;
  final String percentage;

  const Indicator(
      {super.key, required this.paymentCategory, required this.percentage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Container(
      width: context.rSize(150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: context.rSize(15),
            width: context.rSize(15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: paymentCategory.color,
            ),
          ),
          SizedBox(
            width: context.rSize(10),
          ),
          Text(
            ref.watch(pieCharHoldedProvider)
                ? percentage
                : paymentCategory.title,
            style: context.textSmall,
          )
        ],
      ),
    );
  }
}
