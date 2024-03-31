import 'package:cash_swift/auth/user_authentication.dart';
import 'package:cash_swift/main.dart';
import 'package:cash_swift/providers/sign_up/sign_up_data_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

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
                          "Sign Up",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: mq(context, 10),
                        ),
                        Text(
                          "Unlock rapid fast payments in just a few steps!",
                          textAlign: TextAlign.center,
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
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: mq(context, 10),
                                    ),
                                    Text(
                                      "Full Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mandatory Field";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              ref.read(signUpNameProvider.notifier).state =
                                  newValue!;
                            },
                          ),
                        ),
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
                              ref.read(signUpEmailProvider.notifier).state =
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
                              ref.read(signUpPasswordProvider.notifier).state =
                                  newValue!;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: mq(context, 20),
                              vertical: mq(context, 10)),
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.titleMedium,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.withOpacity(0.2),
                                filled: true,
                                counterText: "",
                                prefixText: "+91  ",
                                prefixStyle:
                                    Theme.of(context).textTheme.titleMedium,
                                label: Row(
                                  children: [
                                    const Icon(
                                      Icons.dialpad,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: mq(context, 10),
                                    ),
                                    Text(
                                      "Phone Number",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                )),
                            validator: (value) {
                              if (value!.length != 10 ||
                                  int.parse(value).isNaN) {
                                return "Please enter 10 digit mobile number";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              ref
                                  .read(signUpPhoneNumberProvider.notifier)
                                  .state = newValue!;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: mq(context, 20),
                              vertical: mq(context, 10)),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLength: 4,
                            decoration: InputDecoration(
                                counterText: "",
                                fillColor: Colors.grey.withOpacity(0.2),
                                filled: true,
                                prefixStyle:
                                    Theme.of(context).textTheme.titleMedium,
                                label: Row(
                                  children: [
                                    const Icon(
                                      Icons.pin,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: mq(context, 10),
                                    ),
                                    Text(
                                      "4-Digit-Pin",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                )),
                            validator: (value) {
                              if (value!.length != 4 ||
                                  int.parse(value).isNaN) {
                                return "Please set a 4 digit pin";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              ref.read(signUpPinProvider.notifier).state =
                                  newValue!;
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              initiateSignUp(context, ref);
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.titleMedium,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).go("/signIn");
                      },
                      child: Text(
                        "Already have an account? Sign In",
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

  initiateSignUp(BuildContext context, WidgetRef ref) async {
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
              height: mq(context, 100),
              child: SizedBox(
                height: mq(context, 100),
                width: mq(context, 100),
                child: const CircularProgressIndicator(),
              )),
        );
      },
    );

    final email = ref.read(signUpEmailProvider);
    final password = ref.read(signUpPasswordProvider);
    final userName = ref.read(signUpNameProvider);
    final phoneNumber = ref.read(signUpPhoneNumberProvider);
    final pin = ref.read(signUpPinProvider);
    await UserAuthentication.signUpUser(
        context, email, password, userName, phoneNumber, pin);
  }
}
