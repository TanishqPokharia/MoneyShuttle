import 'package:cash_swift/providers/profile/profile_photo_notifier.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/widgets/profile_info_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileChanging = useState<bool>(false);
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
                      Stack(
                        alignment: Alignment.center,
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
                              child: ref
                                  .watch(profilePhotoProvider(userDetails.msId))
                                  .when(
                                      loading: () => Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              height: context.rSize(100),
                                              width: context.rSize(180),
                                              decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: CircleBorder()),
                                            ),
                                          ),
                                      error: (error, stackTrace) {
                                        print(error);
                                        return ProfilePhoto(
                                          totalWidth: context.rSize(150),
                                          cornerRadius: context.rSize(100),
                                          color: profileChanging.value
                                              ? Colors.grey
                                              : Colors.black,
                                          fontColor: Colors.white,
                                          name: profileChanging.value
                                              ? ""
                                              : userDetails.username,
                                        );
                                      },
                                      data: (data) => profileChanging.value
                                          ? Shimmer.fromColors(
                                              baseColor: Colors.grey,
                                              highlightColor: Colors.white,
                                              child: ProfilePhoto(
                                                totalWidth: context.rSize(150),
                                                cornerRadius:
                                                    context.rSize(100),
                                                color: Colors.grey,
                                              ))
                                          : ProfilePhoto(
                                              totalWidth: context.rSize(150),
                                              cornerRadius: context.rSize(100),
                                              color: Colors.grey,
                                              image: CachedNetworkImageProvider(
                                                  data),
                                              fit: BoxFit.cover,
                                            )),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            right: 30,
                            child: SizedBox(
                              height: context.rSize(45),
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                    color: Colors.white, shape: CircleBorder()),
                                child: IconButton(
                                    color: Colors.black,
                                    onPressed: () async {
                                      profileChanging.value = true;
                                      await ref
                                          .read(profilePhotoNotifierProvider
                                              .notifier)
                                          .changeProfilePhoto(
                                              ref, userDetails.msId);
                                      Future.delayed(Duration(seconds: 3), () {
                                        profileChanging.value = false;
                                      });
                                    },
                                    icon: Icon(CupertinoIcons.camera)),
                              ),
                            ),
                          ),
                        ],
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
