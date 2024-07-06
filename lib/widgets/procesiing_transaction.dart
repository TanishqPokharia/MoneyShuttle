import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class ProcessingTransaction extends HookWidget {
  const ProcessingTransaction({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
        backgroundColor: context.backgroundColor,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Processing transaction...",
                style: context.textMedium,
              ),
              LottieBuilder.network(
                "https://lottie.host/06007e9c-20d3-4862-a6df-735d33e2d7f6/UD1mp4BayJ.json",
                repeat: true,
                fit: BoxFit.cover,
                width: context.rSize(300),
              ),
            ],
          ),
        ));
  }
}
