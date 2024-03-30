import 'package:cash_swift/main.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/models/payment_category.dart';
import 'package:cash_swift/models/transaction_history.dart';
import 'package:cash_swift/providers/home/user_data_provider.dart';
import 'package:cash_swift/widgets/pie_chart_indicator.dart';
import 'package:cash_swift/widgets/transaction_history_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// List<TransactionHistory> historyList = [
//   TransactionHistory(
//       cashSwiftUser: CashSwiftUser(
//           name: "Atharv Kumar Tiwari",
//           id: "9268205935@cashswift",
//           balance: null,
//           phoneNumber: null),
//       paymentCategory: PaymentCategory.entertainment,
//       amount: 1000,
//       time: DateTime.now())
// ];

class TransactionHistoryScreen extends ConsumerWidget {
  TransactionHistoryScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(user));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: appBackgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: appBackgroundColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              userData.when(
                loading: () => CircularProgressIndicator(),
                data: (data) {
                  print(data);
                  return Column(
                    children: [
                      Container(
                        height: mq(context, 400),
                        child: PieChart(PieChartData(
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 0,
                            sectionsSpace: 0,
                            sections: [
                              PieChartSectionData(
                                  title: data[PaymentCategory.leisure.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.leisure.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.leisure.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title:
                                      data[PaymentCategory.entertainment.title]
                                          .toString(),
                                  value: data[
                                          PaymentCategory.entertainment.title] *
                                      1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.entertainment.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.grocery.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.grocery.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.grocery.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.food.title]
                                      .toString(),
                                  value: data[PaymentCategory.food.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.food.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.medicine.title]
                                      .toString(),
                                  value: data[PaymentCategory.medicine.title] *
                                      1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.medicine.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.grocery.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.stationary.title] *
                                          1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.stationary.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.travel.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.travel.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.travel.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.electronics.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.electronics.title] *
                                          1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.electronics.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.bill.title]
                                      .toString(),
                                  value: data[PaymentCategory.bill.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.bill.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.shopping.title]
                                      .toString(),
                                  value: data[PaymentCategory.shopping.title] *
                                      1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.shopping.color,
                                  radius: mq(context, 170)),
                              PieChartSectionData(
                                  title: data[PaymentCategory.others.title]
                                      .toString(),
                                  value:
                                      data[PaymentCategory.others.title] * 1.0,
                                  titleStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  titlePositionPercentageOffset:
                                      mq(context, 0.8),
                                  color: PaymentCategory.others.color,
                                  radius: mq(context, 170))
                            ])),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Indicator(
                                paymentCategory: PaymentCategory.leisure,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.entertainment,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.grocery,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.food,
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Indicator(
                                paymentCategory: PaymentCategory.medicine,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.stationary,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.travel,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.electronics,
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Indicator(
                                paymentCategory: PaymentCategory.bill,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.shopping,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory.others,
                              ),
                              Indicator(
                                paymentCategory: PaymentCategory(
                                    title: "", color: Colors.transparent),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => Text(
                  "Error loading chart",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // ...historyList
              //     .map((e) => TransactionHistoryCard(transactionHistory: e))
              userData.when(
                loading: () => Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: CircularProgressIndicator()),
                data: (snapshot) {
                  if (snapshot['history'].isEmpty) {
                    return Container(
                      margin: EdgeInsets.all(mq(context, 40)),
                      child: Text(
                        "No Past Transactions",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  } else {
                    return Column(
                        children: snapshot['history'].map<Widget>((e) {
                      TransactionHistoryCard transactionHistoryCard =
                          TransactionHistoryCard(
                              transactionHistory: TransactionHistory(
                                  name: e['name'],
                                  paymentCategory: PaymentCategory(
                                      title: e['category'],
                                      color: PaymentCategory.getColorByTitle(
                                          e['category'])),
                                  amount: e['amount'],
                                  time: e['time'],
                                  date: e['date'],
                                  month: e['month'],
                                  year: e['year']));
                      return transactionHistoryCard;
                    }).toList());
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
