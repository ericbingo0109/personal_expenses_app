import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionList(this.transactions);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, //記得要限制個高度給 ListView
      /**
       * ListView(children: [])
       * ListView.builder() // 這種只會load螢幕上可見到的範圍  Only load what visible!
       * 當List很多elements時 使用ListView.builder() 會有較佳的performance
       */
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    // tx.amount.toString(),
                    '\$${transactions[index].amount}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.purple),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple, width: 2)),
                  padding: EdgeInsets.all(10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transactions[index].title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      // DateFormat().format(tx.date),// August 16, 2020 7:17:03 PM
                      // DateFormat('yyyy-MM-dd').format(tx.date),// 2020-08-16
                      // 注意下面這個小時要用大寫HH為24小時制，反之hh則為12小時制
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          transactions[index].date), // 2020-08-16 19:18:30
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      /**
                                 * 更多時間的example 看 第82講
                                 * 或直接去看文件說明https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
                                 */
                      DateFormat.yMMMd()
                          .format(transactions[index].date), // Aug 16, 2020
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                )
              ],
            ),
          );
          //將原本的Card 放在itemBuilder內
          // 也取代了原先transactions.map((tx) {...}).toList(),的方式
        },
        itemCount: transactions.length, // how many items should be build
      ),
    );
  }
}
