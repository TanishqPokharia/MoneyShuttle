import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerifyPin extends StatelessWidget {
  const VerifyPin({super.key, required this.pin, required this.onPinVerified});

  final String pin;
  final Function() onPinVerified;
  // final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: appBackgroundColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: context.rSize(100), bottom: context.rSize(50)),
              child: Text(
                "Enter Pin",
                style: context.textMedium,
              )),
          Pinput(
            length: 4,
            autofocus: true,
            isCursorAnimationEnabled: true,
            obscureText: true,
            obscuringWidget: Container(
              height: context.rSize(15),
              decoration:
                  ShapeDecoration(shape: CircleBorder(), color: Colors.black),
            ),
            cursor: Container(
              color: Colors.black,
              width: 2,
              height: context.rSize(50),
            ),
            validator: (value) {
              return value == pin ? null : "Wrong PIN";
            },
            onCompleted: (value) {
              if (value == pin) {
                onPinVerified();
              }
            },
            errorBuilder: (errorText, pin) {
              return Container(
                margin: EdgeInsets.all(context.rSize(10)),
                child: Text(errorText!,
                    style: context.textSmall!.copyWith(color: Colors.red)),
              );
            },
          )
        ],
      ),
    );
  }
}
