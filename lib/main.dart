import 'package:flutter/material.dart';
import 'widgets/new_transaction.dart';

import './widgets/transaction_list.dart';

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
  // String titleInput;
  // String amountInput; // 新增這兩個變數接受input文字

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
          // mainAxisAlignment: MainAxisAlignment.spaceAround, // default is start
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
            // NewTransaction(),
            // TransactionList()
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
