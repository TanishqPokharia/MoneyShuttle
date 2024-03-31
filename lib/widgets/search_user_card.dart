import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/providers/transaction/category_list_provider.dart';
import 'package:cash_swift/providers/transaction/data_providers.dart';
import 'package:cash_swift/providers/transaction/transaction_loading_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_photo/profile_photo.dart';

class SearchUserCard extends ConsumerWidget {
  const SearchUserCard({super.key, required this.cashSwiftUser});

  final CashSwiftUser cashSwiftUser;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(noteContentProvider.notifier).state = "";
        ref.read(transactionStatusProvider.notifier).state = false;
        ref.read(categoryListProvider.notifier).resetCategories();
        GoRouter.of(context)
            .go("/home/payment/transaction", extra: cashSwiftUser);
      },
      child: Container(
        margin: EdgeInsets.all(mq(context, 10)),
        child: ClipRRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: mq(context, 20)),
                child: ProfilePhoto(
                  totalWidth: mq(context, 90),
                  cornerRadius: mq(context, 50),
                  color: Colors.purple,
                  name: cashSwiftUser.name,
                  nameDisplayOption: NameDisplayOptions.initials,
                  fontColor: Colors.white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cashSwiftUser.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    cashSwiftUser.phoneNumber!,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
