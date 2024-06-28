import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/widgets/profile_info_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: ref.watch(userDataProvider).when(
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                return Center(
                  child: Text("Oops! Something went wrong"),
                );
              },
              data: (data) {
                final userDetails =
                    UserData.fromJson(data.data() as Map<String, dynamic>);
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: context.rSize(300),
                        padding: EdgeInsets.all(context.rSize(20)),
                        decoration: ShapeDecoration(
                            color: Colors.transparent,
                            shape: CircleBorder(
                                side: BorderSide(color: Colors.white))),
                        child: Container(
                          height: context.rSize(200),
                          padding: EdgeInsets.all(context.rSize(10)),
                          decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: CircleBorder(
                                  side: BorderSide(color: Colors.white))),
                          child: ProfilePhoto(
                            color: Colors.black,
                            fontColor: Colors.white,
                            name: userDetails.username,
                            showName: false,
                            image: AssetImage("assets/pic.jpeg"),
                            totalWidth: context.rSize(150),
                            cornerRadius: context.rSize(100),
                          ),
                        ),
                      ),
                      Text(
                        userDetails.username,
                        style: context.textMedium,
                      ),
                      ProfileInfoTile(
                          heading: "Email",
                          headingIcon: Icons.email,
                          content: userDetails.email),
                      ProfileInfoTile(
                          heading: "Phone Number",
                          headingIcon: Icons.phone,
                          content: "+91 ${userDetails.phone}"),
                      ProfileInfoTile(
                          heading: "Money Shuttle ID",
                          headingIcon: Icons.rocket_launch,
                          content: userDetails.msId),
                      Padding(
                        padding: EdgeInsets.only(
                            top: context.rSize(10),
                            left: context.rSize(20),
                            right: context.rSize(20)),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              GoRouter.of(context).go("/signIn");
                            },
                            child: Text('Logout'),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ));
  }
}
