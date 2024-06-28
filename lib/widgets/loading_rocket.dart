import 'package:cash_swift/themes/colors.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class LoadingRocket extends HookWidget {
  const LoadingRocket({super.key});
  @override
  Widget build(BuildContext context) {
    final ticker = useSingleTickerProvider();
    final animationController =
        useAnimationController(vsync: ticker, duration: Duration(seconds: 3))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.pop(context);
            }
          })
          ..forward();
    return Dialog.fullscreen(
      backgroundColor: appBackgroundColor,
      child: FittedBox(
        fit: BoxFit.cover,
        child: DotLottieLoader.fromAsset(
          "assets/Rocket.lottie",
          frameBuilder: (context, dotLottie) {
            if (dotLottie != null) {
              return Lottie.memory(
                controller: animationController,
                dotLottie.animations.values.single,
                repeat: false,
              );
            } else {
              return Container();
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Text("Error");
          },
        ),
      ),
    );
  }
}
