import 'package:flutter/material.dart';
import './transaction.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}
/**
 * 測驗六
 * How much height does a Column take by default?
 * 答案 All available vertical space on the screen
 * 
 * Can Columns and Rows be mixed?
 * Yes, without any limitations.
 * you can absolutely have a Row in a Column, a Column in a Row or Rows in Rows / Columns in Columns.
 * 
 */

class MyHomePage extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
        id: 't1', title: 'new shoes', amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't2',
        title: 'Weekly groceries',
        amount: 16.53,
        date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter App'),
        ),
        body: Column(
          /*
          MainAxisAlignment : 順著Widget發展方向 去記
          如Column : 上下方向 ; Row : 左右方向
          CrossAxisAlignment : 反之
          如Column : 左右方向 ; Row : 上下方向
          */
          crossAxisAlignment: CrossAxisAlignment.center, // default is center
          mainAxisAlignment: MainAxisAlignment.spaceAround, // default is start
          children: <Widget>[
            /* 方法一 Card 裡面的child改用Container去包 然後設定width大小
            Card(
              // child: Text('Chart !'),
              // 若想調整Card size 則必須在 child設定
              child: Container(
                // width: 200,
                width: double.infinity, // take as much width as it can
                child: Text('Chart !'),
              ),
              color: Colors.blue,
              elevation: 5, // 按鈕陰影大小值
            ),
              */
            /*方法二 改用Container 去包整個 Card
             滑鼠游標在 Text 按 Command + . 選擇 wrap with Container
            */
            Container(
              width: double.infinity,
              child: Card(
                child: Text('Chart !'),
                elevation: 5,
                color: Colors.blue,
              ),
            ),
            Column(
              children: transactions.map((tx) {
                /*
                return Card(
                  child: Text(tx.title),
                );
                */
                return Row(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(
                        // tx.amount.toString(),
                        '\$${tx.amount}',
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
                          tx.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          // DateFormat().format(tx.date),// August 16, 2020 7:17:03 PM
                          // DateFormat('yyyy-MM-dd').format(tx.date),// 2020-08-16
                          // 注意下面這個小時要用大寫HH為24小時制，反之hh則為12小時制
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(tx.date), // 2020-08-16 19:18:30
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          /**
                           * 更多時間的example 看 第82講
                           * 或直接去看文件說明https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
                           */
                          DateFormat.yMMMd().format(tx.date), // Aug 16, 2020
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    )
                  ],
                );
              }).toList(),
            )
            /*
            Card(
              child: Text('List of tx '),
              color: Colors.red,
            )
            */
          ],
        ));
  }
}
