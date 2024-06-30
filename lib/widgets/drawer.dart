import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/providers/home/check_balance_provider.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/router/router_config.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/widgets/loading_rocket.dart';
import 'package:cash_swift/widgets/theme_toggle.dart';
import 'package:cash_swift/widgets/verify_pin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:shimmer/shimmer.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
        backgroundColor: Colors.grey.shade900,
        child: ref.watch(userDataProvider).when(
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) {
                print(error);
                return Center(
                  child: Text("Error fetching data", style: context.textMedium),
                );
              },
              data: (data) {
                final userDetails =
                    UserData.fromJson(data.data() as Map<String, dynamic>);
                return Column(
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
                              ref
                                  .watch(profilePhotoProvider(userDetails.msId))
                                  .when(
                                      loading: () => Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: Colors.white,
                                            child: ProfilePhoto(
                                              totalWidth: context.rSize(120),
                                              cornerRadius: context.rSize(60),
                                              color: Colors.grey,
                                            ),
                                          ),
                                      error: (error, stackTrace) {
                                        print(error);
                                        return ProfilePhoto(
                                          totalWidth: context.rSize(120),
                                          cornerRadius: context.rSize(60),
                                          color: Colors.black,
                                          fontColor: Colors.white,
                                          name: userDetails.username,
                                        );
                                      },
                                      data: (data) => ProfilePhoto(
                                            totalWidth: context.rSize(120),
                                            cornerRadius: context.rSize(60),
                                            color: Colors.grey,
                                            image: CachedNetworkImageProvider(
                                                data),
                                            fit: BoxFit.cover,
                                          ))
                              // ProfilePhoto(
                              //     name: username,
                              //     nameDisplayOption: NameDisplayOptions.initials,
                              //     totalWidth: context.rSize(100),
                              //     cornerRadius: context.rSize(100),
                              //     color: Colors.green,
                              //     fontColor: Colors.white),
                              ,
                              Text(
                                userDetails.username,
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => VerifyPin(
                            pin: userDetails.pin,
                            onPinVerified: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                          ),
                        );
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
                );
              },
            ));
  }
}
