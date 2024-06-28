import 'package:cash_swift/data/month_list.dart';
import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/models/transaction_history.dart';
import 'package:cash_swift/models/user_history/user_history.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/providers/history/pieCharHoldedProvider.dart';
import 'package:cash_swift/providers/history/transactionsFilterProvider.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:cash_swift/widgets/category_types.dart';
import 'package:cash_swift/widgets/transaction_history_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  TransactionHistoryScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;
  final yearList = [0, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: context.textLarge,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: appBackgroundColor,
        height: context.screenHeight,
        width: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(context.rSize(20)),
                    child: Text(
                      "Expenditure:",
                      style: context.textMedium,
                    ),
                  ),
                  userData.when(
                    loading: () => const CircularProgressIndicator(),
                    data: (data) {
                      return Text(
                        "₹ ${data['expenditure'].toString()}",
                        style: context.textMedium,
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(
                        "Network error",
                        style: context.textMedium,
                      );
                    },
                  )
                ],
              ),
              userData.when(
                loading: () => CircularProgressIndicator(),
                data: (data) {
                  if (data['history'].isEmpty) {
                    return Container();
                  } else {
                    final paymentCategory = data.get("paymentCategory");
                    final expenditure = data.get("expenditure");
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            onTap: () {
                              ref.read(pieCharHoldedProvider.notifier).state =
                                  !ref
                                      .read(pieCharHoldedProvider.notifier)
                                      .state;
                            },
                            child: PieChart(
                                swapAnimationDuration:
                                    Duration(milliseconds: 500),
                                swapAnimationCurve: Curves.fastOutSlowIn,
                                PieChartData(
                                    borderData: FlBorderData(show: false),
                                    sectionsSpace:
                                        ref.watch(pieCharHoldedProvider)
                                            ? 7
                                            : 0,
                                    centerSpaceRadius: 0,
                                    sections: PaymentCategory.list
                                        .map((category) => PieChartSectionData(
                                            title: "",
                                            // title:
                                            //     "${(((data['paymentCategory'][category.title]) / data['expenditure']) * 100).toStringAsFixed(2)} %",
                                            value: (data['paymentCategory']
                                                        [category.title] *
                                                    1.0) /
                                                data['expenditure'],
                                            titleStyle: context.textSmall!
                                                .copyWith(
                                                    fontSize:
                                                        context.rSize(22)),
                                            titlePositionPercentageOffset:
                                                context.rSize(1),
                                            color: category.color,
                                            radius: context.rSize(170)))
                                        .toList())),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.rSize(10)),
                          child: CategoryTypes(
                            paymentCategory: paymentCategory,
                            expenditure: expenditure.toDouble(),
                          ),
                        )
                      ],
                    );
                  }
                },
                error: (error, stackTrace) => Text(
                  "Error loading chart",
                  style: context.textMedium,
                ),
              ),
              userData.when(
                loading: () => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(context.rSize(20)),
                    child: CircularProgressIndicator()),
                data: (snapshot) {
                  final transactionHistory = snapshot.get("history") as List;
                  if (transactionHistory.isEmpty) {
                    return Container(
                      margin: EdgeInsets.all(context.rSize(40)),
                      child: Text(
                        "No Past Transactions",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  } else {
                    final month = ref.watch(monthFilterProvider);
                    final year = ref.watch(yearFilterProvider);
                    return Column(children: [
                      Padding(
                        padding: EdgeInsets.all(context.rSize(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton(
                              value: ref.watch(monthFilterProvider),
                              onChanged: (value) {
                                ref.read(monthFilterProvider.notifier).state =
                                    value!;
                              },
                              items: [
                                ...monthList.map((e) => DropdownMenuItem(
                                    value: monthList.indexOf(e) + 1,
                                    child: Text(e)))
                              ],
                            ),
                            DropdownButton(
                              value: ref.watch(yearFilterProvider),
                              onChanged: (value) {
                                ref.read(yearFilterProvider.notifier).state =
                                    value!;
                              },
                              items: [
                                ...yearList.map((e) => DropdownMenuItem(
                                    value: DateTime.now().year - e,
                                    child: Text("${DateTime.now().year - e}")))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: context.rSize(500),
                        child: ListView.separated(
                          itemCount: transactionHistory.where((element) {
                            return element['year'] == year &&
                                element['month'] == month;
                          }).length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: context.rSize(10),
                            );
                          },
                          itemBuilder: (context, index) {
                            final userHistory =
                                UserHistory.fromJson(transactionHistory[index]);
                            return TransactionHistoryTile(
                              transactionHistory: TransactionHistory(
                                  name: userHistory.username,
                                  amount: userHistory.amount,
                                  paymentCategory: PaymentCategory(
                                      title: userHistory.category,
                                      color: PaymentCategory.getColorByTitle(
                                          userHistory.category)),
                                  note: userHistory.note,
                                  time: userHistory.time,
                                  month: userHistory.month,
                                  year: userHistory.year,
                                  date: userHistory.date),
                            );
                          },
                        ),
                      )
                    ]);
                  }
                },
                error: (error, stackTrace) => Text(
                  "Failed to load history",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
