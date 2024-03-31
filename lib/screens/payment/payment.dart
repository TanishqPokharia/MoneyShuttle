import 'package:cash_swift/main.dart';
import 'package:cash_swift/providers/payment/payee_list_provider.dart';
import 'package:cash_swift/widgets/search_user_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends ConsumerWidget {
  PaymentScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Payee",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: appBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Form(
          key: formKey,
          child: Container(
            color: appBackgroundColor,
            padding: EdgeInsets.all(mq(context, 20)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      ref.read(payeeProvider.notifier).getPayee(value);
                      print(ref.read(payeeProvider));
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: mq(context, 24)),
                        label: const Text("Search"),
                        hintText: "Phone Number",
                        hintStyle: const TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: mq(context, 50),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return SearchUserCard(
                            cashSwiftUser: ref.watch(payeeProvider).first);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: mq(context, 10),
                      ),
                      itemCount: ref.watch(payeeProvider).length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
