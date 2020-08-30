import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';
import './widgets/new_transaction.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      // use theme to set up a global application-wide theme
      theme: ThemeData(
        //有別於primaryColor僅設定單一顏色，primarySwatch會基於一種顏色以外還會自動產生陰影效果
        primarySwatch: Colors.amber, // 主要顏色
        /**
         * 問題：What's the difference between primarySwatch and primaryColor?
         * 解答：primarySwatch is a collection of different color shades.
         * That's correct. You get different shades which some Flutter widgets automatically use.
         */
        // 次要顏色，沒有設定則依照primarySwatch，有設定的話，例如 floating action button 就會依照這顏色
        accentColor: Colors.green,
        /**
         * 問題：How do you use a text theme on a Text() widget?
         * 解答：Define globally, use via the style argument.
         * 
         */
        //其他地方也想直接套用這個textTheme的title style的話，可設定 style: Theme.of(context).textTheme.title
        //即可吃到同樣的TextStyle, 見 transaction_list.dart : 59
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        fontFamily: 'Quicksand', // 要跟我在 pubspec.yaml 設定的font字串相符
      ),
      home: MyHomePage(),
    );
  }
}
/*
 * 測驗六
 * How much height does a Column take by default?
 * 答案 All available vertical space on the screen
 * 
 * Can Columns and Rows be mixed?
 * Yes, without any limitations.
 * you can absolutely have a Row in a Column, a Column in a Row or Rows in Rows / Columns in Columns.
 * 
 */

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput; // 新增這兩個變數接受input文字

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'new shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
  ];
  void _addNewTransaction(String txTitle, double txAmount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // showModalBottomSheet 是 flutter內建的
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(
            addTx: _addNewTransaction,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
          //與整體theme font不一樣時就自行設定, 可是一旦頁面很多時這樣設定就很麻煩
          // 所以較佳的做法是設定 appBarTheme
          // style: TextStyle(fontFamily: 'OpenSans'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), //Icons有許多內建icon可選擇
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      ),
      body: Column(
        /*
                MainAxisAlignment : 順著Widget發展方向 去記
                如Column : 上下方向 ; Row : 左右方向
                CrossAxisAlignment : 反之
                如Column : 左右方向 ; Row : 上下方向
                */
        crossAxisAlignment: CrossAxisAlignment.center, // default is center
        // verticalDirection: VerticalDirection.down,
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
          TransactionList(_userTransactions),
          // NewTransaction(),
          // TransactionList()
          /*
                  Card(
                    child: Text('List of tx '),
                    color: Colors.red,
                  )
                  */
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
