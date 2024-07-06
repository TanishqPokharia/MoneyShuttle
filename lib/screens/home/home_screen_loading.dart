import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/widgets/drawer.dart';
import 'package:cash_swift/widgets/feature_card.dart';
import 'package:cash_swift/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenLoading extends StatelessWidget {
  const HomeScreenLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(left: context.rSize(10)),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: HomeScreenShimmer(),
      ),
    );
  }
}

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserMoneyShuttleCard(msId: "", username: "", onPressQR: () {}),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FeatureCard(
                    title: null,
                    icon: null,
                    color: null,
                    splashColor: null,
                    image: null,
                    onTap: null),
                FeatureCard(
                    title: null,
                    icon: null,
                    color: null,
                    splashColor: null,
                    image: null,
                    onTap: null),
              ],
            ),
          )
        ],
      ),
    );
  }
}
