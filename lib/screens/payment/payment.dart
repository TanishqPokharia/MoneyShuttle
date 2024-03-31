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

// final filterListProvider = StateProvider<List<CashSwiftUser>>((ref) {
//   return userList;
// });

// final userList = [
//   CashSwiftUser(
//     name: 'User 1',
//     id: '1234567890@cashswift',
//     number: '1234567890',
//   ),
//   CashSwiftUser(
//     name: 'User 2',
//     id: '2345678901@cashswift',
//     number: '2345678901',
//   ),
//   CashSwiftUser(
//     name: 'User 3',
//     id: '3456789012@cashswift',
//     number: '3456789012',
//   ),
//   CashSwiftUser(
//     name: 'User 4',
//     id: '4567890123@cashswift',
//     number: '4567890123',
//   ),
//   CashSwiftUser(
//     name: 'User 5',
//     id: '5678901234@cashswift',
//     number: '5678901234',
//   ),
//   CashSwiftUser(
//     name: 'User 6',
//     id: '6789012345@cashswift',
//     number: '6789012345',
//   ),
//   CashSwiftUser(
//     name: 'User 7',
//     id: '7890123456@cashswift',
//     number: '7890123456',
//   ),
//   CashSwiftUser(
//     name: 'User 8',
//     id: '8901234567@cashswift',
//     number: '8901234567',
//   ),
//   CashSwiftUser(
//     name: 'User 9',
//     id: '9012345678@cashswift',
//     number: '9012345678',
//   ),
//   CashSwiftUser(
//     name: 'User 10',
//     id: '0123456789@cashswift',
//     number: '0123456789',
//   ),
//   CashSwiftUser(
//     name: 'User 11',
//     id: '1122334455@cashswift',
//     number: '1122334455',
//   ),
//   CashSwiftUser(
//     name: 'User 12',
//     id: '2233445566@cashswift',
//     number: '2233445566',
//   ),
//   CashSwiftUser(
//     name: 'User 13',
//     id: '3344556677@cashswift',
//     number: '3344556677',
//   ),
//   CashSwiftUser(
//     name: 'User 14',
//     id: '4455667788@cashswift',
//     number: '4455667788',
//   ),
//   CashSwiftUser(
//     name: 'User 15',
//     id: '5566778899@cashswift',
//     number: '5566778899',
//   ),
// ];
