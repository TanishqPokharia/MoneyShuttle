import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart' as Shine;

class UserMoneyShuttleCard extends StatelessWidget {
  const UserMoneyShuttleCard(
      {super.key,
      required this.msId,
      required this.username,
      required this.onPressQR});

  final String msId;
  final String username;
  final void Function() onPressQR;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: context.rSize(50),
          bottom: context.rSize(10),
          left: context.rSize(20),
          right: context.rSize(20)),
      child: Shine.Shimmer(
        interval: Duration(seconds: 3),
        child: Material(
          borderRadius: BorderRadius.circular(context.rSize(20)),
          type: MaterialType.card,
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(context.rSize(20)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.rSize(10)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                      Colors.grey.shade700,
                      Colors.grey.shade600,
                      Colors.grey.shade700,
                      Colors.grey.shade900
                    ])),
            width: double.infinity,
            height: context.rSize(250),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "MoneyShuttle",
                        style: context.textMedium,
                      ),
                    ),
                    Image.asset(
                      "assets/chip.png",
                      height: context.rSize(80),
                      width: context.rSize(80),
                    ),
                    Container(
                      child: Text(
                        msId,
                        style: context.textSmall!
                            .copyWith(fontSize: context.rSize(20)),
                      ),
                    ),
                    Container(
                      width: context.rSize(250),
                      child: Text(
                        username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textMedium,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: context.rSize(150),
                        width: context.rSize(150),
                        child: GestureDetector(
                          onTap: onPressQR,
                          child: QrImageView(
                            eyeStyle: const QrEyeStyle(
                                color: Colors.white,
                                eyeShape: QrEyeShape.square),
                            dataModuleStyle: const QrDataModuleStyle(
                                color: Colors.white,
                                dataModuleShape: QrDataModuleShape.square),
                            data: msId,
                          ),
                        )),
                    Container(
                      child: Text(
                        "QR Code",
                        style: context.textSmall,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
