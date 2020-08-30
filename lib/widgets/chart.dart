import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> currentTransactions;

  Chart({this.currentTransactions});
/**
 * List<Map<String, Object>> 最後再打 不然vs code有點怪怪的一直報錯...
 */
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      // Duration 可選days, hours, minutes, seconds,..etc
      // substract 多久以前
      // final weekDay = DateTime.now().add(Duration(days: index));
      // add 多久之後
      final weekDay = DateTime.now().subtract(Duration(days: index));
      // import intl.dart for using DateFormat
      return {'Day': DateFormat.E(weekDay), 'amount': 9.99};
      // DateFormat.E(weekDay) 會顯示那天的shortcut ex: Monday -> M ; Tuesday -> T
    });
  }

  @override
  Widget build(BuildContext context) {
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
