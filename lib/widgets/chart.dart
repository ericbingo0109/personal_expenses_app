import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> currentTransactions;

  Chart(this.currentTransactions);
/**
 * 動態產生過去七天的expense狀況
 * List<Map<String, Object>> 最後再打 不然vs code有點怪怪的一直報錯...
 */
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // Duration 可選days, hours, minutes, seconds,..etc
      // substract 多久以前
      // final weekDay = DateTime.now().add(Duration(days: index));
      // add 多久之後
      final weekDay = DateTime.now().subtract(Duration(days: index));

      var totalSum = 0.0;

      for (int i = 0; i < currentTransactions.length; i++) {
        if (currentTransactions[i].date.day == weekDay.day &&
            currentTransactions[i].date.month == weekDay.month && // 7月即7
            // 西元年
            currentTransactions[i].date.year == weekDay.year) {
          totalSum += currentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);

      // import intl.dart for using DateFormat
      return {'Day': DateFormat.E().format(weekDay), 'amount': totalSum};
      // DateFormat.E().format(weekDay) 會顯示那天的shortcut ex: Monday -> Mon ; Tuesday -> Tue
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactionValues;
    return Card(
      elevation: 6, // 陰影大小
      margin: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          //
        ],
      ),
    );
  }
}
