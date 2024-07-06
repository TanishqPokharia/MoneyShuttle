import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profile_photo/profile_photo.dart';

class HomeScreenError extends StatelessWidget {
  const HomeScreenError({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      drawer: AppDrawer(),
      appBar: AppBar(
          title: Text('Home'),
          leading: ProfilePhoto(
            totalWidth: context.rSize(50),
            cornerRadius: context.rSize(50),
            color: Colors.black,
            fontColor: Colors.white,
            name: user!.displayName!,
            onTap: () => Scaffold.of(context).openDrawer(),
          )),
      body: Center(
        child: Text('Oops! Something went wrong', style: context.textMedium),
      ),
    );
  }
}
