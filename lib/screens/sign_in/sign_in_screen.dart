import 'package:cash_swift/auth/user_authentication.dart';
import 'package:cash_swift/main.dart';
import 'package:cash_swift/providers/sign_in/sign_in_data_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              color: appBackgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(mq(context, 20)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/logonocaption.png",
                      height: mq(context, 150),
                    ),
                    Column(
                      children: [
                        Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: mq(context, 10),
                        ),
                        Text(
                          "Welcome back! Let's get you back inside",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: mq(context, 20)),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: mq(context, 20),
                              vertical: mq(context, 10)),
                          child: TextFormField(
                            style: Theme.of(context).textTheme.titleMedium,
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
                                      width: mq(context, 10),
                                    ),
                                    Text(
                                      "Email",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                              ref.read(signInEmailProvider.notifier).state =
                                  newValue!;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: mq(context, 20),
                              vertical: mq(context, 10)),
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
                                      width: mq(context, 10),
                                    ),
                                    Text(
                                      "Password",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                              ref.read(signInPasswordProvider.notifier).state =
                                  newValue!;
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
                              final email = ref.read(signInEmailProvider);
                              final password = ref.read(signInPasswordProvider);
                              await UserAuthentication.signInUser(
                                  context, email, password);
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go("/signUp");
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: mq(context, 20),
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
