import 'package:flutter/material.dart';
import '../widgets/chart_bar.dart';
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
      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      // import intl.dart for using DateFormat
      return {
        'Day': DateFormat.E()
            .format(weekDay)
            .toString()
            .substring(0, 1), // 改為只取第一個英文字
        'amount': totalSum,
      };
      // DateFormat.E().format(weekDay) 會顯示那天的shortcut ex: Monday -> Mon ; Tuesday -> Tue
    }).reversed.toList();
    // reverse 原先的list順序，將今日的bar放在最右邊，向左遞減到七天前的bar，較符合視覺習慣
  }

  double get totalSpending {
    // fold Reduces a collection to a single value by iteratively combining each element of the collection with an existing value
    /**
     * reduce函數主要用於集合中元素依次歸納(combine)，每次歸納後的結果會和下一個元素進行歸納，
     * 它可以用來累加或累乘，具體取決於combine函數中操作，combine函數中會回調上一次歸納後的值和當前元素值，
     * reduce提供的是獲取累積疊代結果的便利條件. 
     * 
     * fold和reduce幾乎相同，唯一區別是fold可以指定初始值。 
     * 但是需要注意的是，combine函數返回值的類型必須和集合泛型類型一致。
     */
    // return groupedTransactionValues.fold(initialValue, (previousValue, element) => null)
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // 陰影大小
      margin: EdgeInsets.all(20),
      child: Container(
        // 如果只要單純調整padding的話, 這邊也可將Container改為Padding
        padding: EdgeInsets.all(10), // 加一點padding 不讓bar太靠近card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            // 注意這邊取值時 key大小寫別寫錯
            // return Text('${data['Day']} : ${data['amount']}');
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['Day'],
                data['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending,
                // 告訴Dart data['amount'] 為 double
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
