import 'package:cash_swift/auth/user_authentication.dart';
import 'package:cash_swift/providers/profile/profile_photo_provider.dart';
import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInScreen extends HookConsumerWidget {
  SignInScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentials =
        useRef<Map<String, String>>({"email": "", "password": ""});
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            color: appBackgroundColor,
            width: context.screenWidth,
            height: context.screenHeight,
            padding: EdgeInsets.all(context.rSize(20)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/mslogo.png",
                    height: context.rSize(250),
                  ),
                  Column(
                    children: [
                      Text(
                        "Sign In",
                        style: context.textLarge,
                      ),
                      SizedBox(
                        height: context.rSize(10),
                      ),
                      Text(
                        "Welcome back! Let's get you back inside",
                        style: context.textSmall!
                            .copyWith(fontSize: context.rSize(20)),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(20),
                            vertical: context.rSize(10)),
                        child: TextFormField(
                          style: context.textMedium,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.withOpacity(0.2),
                              filled: true,
                              label: Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: context.rSize(10),
                                  ),
                                  Text(
                                    "Email",
                                    style: context.textMedium,
                                  ),
                                ],
                              )),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains("@") ||
                                !value.contains(".com")) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            credentials.value['email'] = newValue!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(20),
                            vertical: context.rSize(10)),
                        child: TextFormField(
                          obscureText: true,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.withOpacity(0.2),
                              filled: true,
                              label: Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: context.rSize(10),
                                  ),
                                  Text(
                                    "Password",
                                    style: context.textMedium,
                                  ),
                                ],
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            credentials.value['password'] = newValue!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await initiateSignUp(context, credentials.value);
                            await ref.refresh(userDataProvider.future);
                          }
                        },
                        child: Text(
                          "Sign In",
                          style: context.textMedium,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go("/signUp");
                    },
                    child: Text(
                      "Don't have an account? Sign Up",
                      style: context.textSmall!.copyWith(
                          fontSize: context.rSize(20),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  initiateSignUp(BuildContext context, Map<String, String> credentials) async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          backgroundColor: Colors.transparent,
          child: Container(
              alignment: Alignment.center,
              height: context.rSize(100),
              child: SizedBox(
                height: context.rSize(100),
                width: context.rSize(100),
                child: const CircularProgressIndicator(),
              )),
        );
      },
    );

    final email = credentials['email'];
    final password = credentials['password'];
    await UserAuthentication.signInUser(context, email!, password!);
  }
}
