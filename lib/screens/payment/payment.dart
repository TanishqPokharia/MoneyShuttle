import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/providers/payment/payee_list_provider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/widgets/search_user_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends ConsumerWidget {
  PaymentScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Payee",
          style: context.textLarge,
        ),
        backgroundColor: appBackgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: formKey,
        child: Container(
          color: appBackgroundColor,
          padding: EdgeInsets.all(context.rSize(20)),
          height: context.screenHeight,
          width: context.screenWidth,
          child: SafeArea(
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    ref.read(payeeProvider.notifier).getPayee(value);
                    print(ref.read(payeeProvider));
                  },
                  decoration: InputDecoration(
                      labelStyle: context.textMedium,
                      label: const Text("Search"),
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: context.rSize(50),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return SearchUserTile(
                          cashSwiftUser: ref.watch(payeeProvider).first);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: context.rSize(10),
                    ),
                    itemCount: ref.watch(payeeProvider).length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
