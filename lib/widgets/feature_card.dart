import 'package:cash_swift/extensions.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.splashColor,
      required this.image,
      required this.onTap});
  final String? title;
  final IconData? icon;
  final Color? color;
  final Color? splashColor;
  final Image? image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.rSize(10)),
      padding: EdgeInsets.all(context.rSize(10)),
      height: context.rSize(200),
      width: context.rSize(250),
      child: Card(
        color: color,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor,
          highlightColor: splashColor,
          borderRadius: BorderRadius.circular(context.rSize(10)),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Opacity(
                opacity: 0.7,
                child: image,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(context.rSize(10)),
                width: context.rSize(200),
                child: Text(
                  title ?? "",
                  style: context.textMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.all(context.rSize(10)),
                  child: Icon(
                    icon,
                    size: context.rSize(50),
                    color: Colors.white.withOpacity(0.8),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
