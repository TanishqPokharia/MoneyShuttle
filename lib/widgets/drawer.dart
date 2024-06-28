import 'package:cash_swift/cloud_storage/cloud_storage.dart';
import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/widgets/loading_rocket.dart';
import 'package:cash_swift/widgets/theme_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfilePhoto(
                        name: username,
                        nameDisplayOption: NameDisplayOptions.initials,
                        totalWidth: context.rSize(100),
                        cornerRadius: context.rSize(100),
                        color: Colors.green,
                        fontColor: Colors.white),
                    Text(
                      username,
                      style: context.textMedium,
                    )
                  ],
                ),
                ThemeToggle()
              ],
            ),
          ),
          ListTile(
            onTap: () {
              GoRouter.of(context).push("/home/profile");
            },
            leading: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
            ),
            title: Text("Profile", style: context.textMedium),
          ),
          ListTile(
            onTap: () async {
              await CloudStorage.uploadProfilePicture();
            },
            leading: Icon(
              Icons.account_balance,
              color: Colors.white,
            ),
            title: Text("Check Balance", style: context.textMedium),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.draw,
              color: Colors.white,
            ),
            title: Text("Customize", style: context.textMedium),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => LoadingRocket(),
              );
            },
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text(
              "Settings",
              style: context.textMedium,
            ),
          )
        ],
      ),
    );
  }
}
