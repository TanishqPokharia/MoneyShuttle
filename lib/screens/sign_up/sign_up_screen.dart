import 'package:cash_swift/auth/user_authentication.dart';
import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpScreen extends HookConsumerWidget {
  SignUpScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentials = useRef<Map<String, String>>(
        {"email": "", "password": "", "username": "", "phone": "", "pin": ""});
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
                    "assets/logonocaption.png",
                    height: context.rSize(150),
                  ),
                  Column(
                    children: [
                      Text(
                        "Sign Up",
                        style: context.textLarge,
                      ),
                      SizedBox(
                        height: context.rSize(10),
                      ),
                      Text(
                        "Unlock rapid fast payments in just a few steps!",
                        textAlign: TextAlign.center,
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
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: context.rSize(10),
                                  ),
                                  Text(
                                    "Full Name",
                                    style: context.textMedium,
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
                            credentials.value["username"] = newValue!;
                          },
                        ),
                      ),
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
                            credentials.value["email"] = newValue!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(20),
                            vertical: context.rSize(10)),
                        child: TextFormField(
                          obscureText: true,
                          style: context.textMedium,
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
                            credentials.value["password"] = newValue!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(20),
                            vertical: context.rSize(10)),
                        child: TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: context.textMedium,
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
                                    width: context.rSize(10),
                                  ),
                                  Text(
                                    "Phone Number",
                                    style: context.textMedium,
                                  ),
                                ],
                              )),
                          validator: (value) {
                            if (value!.length != 10 || int.parse(value).isNaN) {
                              return "Please enter 10 digit mobile number";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            credentials.value["phone"] = newValue!;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(20),
                            vertical: context.rSize(10)),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          style: context.textMedium,
                          maxLength: 4,
                          decoration: InputDecoration(
                              counterText: "",
                              fillColor: Colors.grey.withOpacity(0.2),
                              filled: true,
                              prefixStyle: context.textMedium,
                              label: Row(
                                children: [
                                  const Icon(
                                    Icons.pin,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: context.rSize(10),
                                  ),
                                  Text(
                                    "4-Digit-Pin",
                                    style: context.textMedium,
                                  ),
                                ],
                              )),
                          validator: (value) {
                            if (value!.length != 4 || int.parse(value).isNaN) {
                              return "Please set a 4 digit pin";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            credentials.value["pin"] = newValue!;
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            initiateSignUp(context, credentials.value);
                            await ref.refresh(userDataProvider.future);
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: context.textMedium,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go("/signIn");
                    },
                    child: Text(
                      "Already have an account? Sign In",
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

  void initiateSignUp(
      BuildContext context, Map<String, String> credentials) async {
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

    final email = credentials["email"];
    final password = credentials["password"];
    final userName = credentials["username"];
    final phoneNumber = credentials["phone"];
    final pin = credentials["pin"];

    await UserAuthentication.signUpUser(
        context,
        CashSwiftUser(
            email: email,
            username: userName!,
            id: null,
            balance: 0,
            phoneNumber: phoneNumber),
        password!,
        pin!);
  }
}
