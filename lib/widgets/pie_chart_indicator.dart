import 'package:cash_swift/models/payment_category.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final PaymentCategory paymentCategory;

  const Indicator({super.key, required this.paymentCategory});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: mq(context, 5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: mq(context, 15),
            width: mq(context, 15),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: paymentCategory.color,
            ),
          ),
          SizedBox(
            width: mq(context, 10),
          ),
          Text(paymentCategory.title,
              style: Theme.of(context).textTheme.titleSmall)
        ],
      ),
    );
  }
}
