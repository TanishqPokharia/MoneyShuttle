import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/models/user_data/user_data.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomQRScreen extends HookConsumerWidget {
  CustomQRScreen({super.key});

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountHook = useState<int>(0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text("Custom QR"),
      ),
      body: Form(
          key: formKey,
          child: ref.watch(userDataProvider).when(
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    "Oops! Could not fetch data",
                    style: context.textMedium,
                  ),
                ),
                data: (data) {
                  final userDetails =
                      UserData.fromJson(data.data() as Map<String, dynamic>);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.rSize(150),
                            vertical: context.rSize(40)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == "0" ||
                                int.tryParse(value!) == null ||
                                int.parse(value) < 0) {
                              return "Invalid Amount";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            amountHook.value = int.parse(newValue!);
                          },
                          keyboardType: TextInputType.number,
                          style: Theme.of(context).textTheme.titleLarge,
                          cursorColor: Colors.blue,
                          decoration: const InputDecoration(
                              hintText: "   0",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlue)),
                              disabledBorder: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              prefixIcon: Icon(
                                Icons.currency_rupee_sharp,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                            }
                          },
                          child: Text(
                            "Generate QR",
                            style: context.textSmall,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: context.rSize(20)),
                        child: Container(
                            child: amountHook.value > 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      QrImageView(
                                        size: context.rSize(300),
                                        backgroundColor: Colors.white,
                                        eyeStyle: const QrEyeStyle(
                                            color: Colors.black,
                                            eyeShape: QrEyeShape.square),
                                        dataModuleStyle:
                                            const QrDataModuleStyle(
                                                color: Colors.black,
                                                dataModuleShape:
                                                    QrDataModuleShape.square),
                                        data:
                                            "${amountHook.value}/${userDetails.msId}",
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: context.rSize(30)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_sharp,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              amountHook.value.toString(),
                                              style: context.textLarge,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                : null),
                      )
                    ],
                  );
                },
              )),
    );
  }
}
