import 'package:cash_swift/extensions.dart';
import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile(
      {super.key,
      required this.heading,
      required this.headingIcon,
      required this.content});

  final String heading;
  final IconData headingIcon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.rSize(20), vertical: context.rSize(10)),
      child: ListTile(
        iconColor: Colors.white,
        shape:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              heading,
              style: context.textSmall,
            ),
            SizedBox(
              width: context.rSize(10),
            ),
            Icon(
              headingIcon,
              size: context.rSize(20),
            )
          ],
        ),
        subtitle: Text(
          content,
          style: context.textMedium!.copyWith(fontSize: context.rSize(22)),
        ),
      ),
    );
  }
}
