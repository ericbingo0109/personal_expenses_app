import 'dart:io'; //io包放在最上面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
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
        accentColor: Colors.purple,
        /**
         * 問題：How do you use a text theme on a Text() widget?
         * 解答：Define globally, use via the style argument.
         * 
         */
        //其他地方也想直接套用這個textTheme的title style的話，可設定 style: Theme.of(context).textTheme.title
        //即可吃到同樣的TextStyle, 見 transaction_list.dart : 59
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
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

  // 回傳七天前到現在的transactions
  List<Transaction> get _recentTransactions {
    // 類似sql語句的where條件
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
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

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

/**
 * landscape: 橫式螢幕
 * portrait: 直立螢幕
 */

  List<Widget> _buildLandscapeContent(
      double chartHeight, Container txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          // adaptive constructor 可讓switch 依據平台的不同，自動調整其外觀
          // 例：ios switch外觀會比較粗 android switch則比較細
          Switch.adaptive(
              // switch on時 拉條的顏色跟著accentColor
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
//透過 Container 包覆後再去分配剩餘可用的高度給這兩個主要的Widget (Chart & TransactionList)
      _showChart
          ? Container(
              height: chartHeight,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      double chartHeight, Container txListWidget) {
    return [
      Container(
        height: chartHeight,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // user的裝置是否為水平狀態
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    /**
     * textScaleFactor tells you by how much text output in the app should be scaled. 
     * Users can change this in their mobile phone / device settings.
     * textScaleFactor default值是1 (如果user 沒有改字體setting)
     */
    final curScaleFactor = mediaQuery.textScaleFactor;

    // AppBar assign為一個參數方便其他Widget可以得知其高度等其他數據
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            // middle 同title
            middle: Text(
              'Personal Expenses',
              style: TextStyle(fontSize: 14 * curScaleFactor),
            ),
            // trailing 同 action
            trailing: Row(
              // mainAxisSize default is max
              mainAxisSize:
                  MainAxisSize.min, // 設定min row will shrink along its main axis
              children: <Widget>[
                /* 下面這邊如果照抄原本寫法的話會報錯 因IconButton實作父類非ios widget
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: () => _startAddNewTransaction(context),
                )*/
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                  ),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
              //與整體theme font不一樣時就自行設定, 可是一旦頁面很多時這樣設定就很麻煩
              // 所以較佳的做法是設定 appBarTheme
              // style: TextStyle(fontFamily: 'OpenSans'),
              // 如果user有更改字體大小setting時 藉由curScaleFactor會隨著其設定而動態改變字體大小
              style: TextStyle(fontSize: 14 * curScaleFactor),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add), //Icons有許多內建icon可選擇
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    /**
     * 剩下可用的高度 = 整個裝置高度 - appBar高度 - 狀態列高度;
     */
    final remainAvailableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    double chartHeight = remainAvailableHeight * 0.4;
    double txListHeight = remainAvailableHeight * 0.6;

    if (isLandscape) {
      chartHeight = remainAvailableHeight * 0.7;
      txListHeight = remainAvailableHeight * 0.7;
    }

    final txListWidget = Container(
      height: txListHeight,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
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
            // 當裝置為landscape時 才顯示Switch
            if (isLandscape)
              ..._buildLandscapeContent(chartHeight, txListWidget),
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
            // Container(
            //   width: double.infinity,
            //   child: Card(
            //     child: Text('Chart !'),
            //     elevation: 5,
            //     color: Colors.blue,
            //   ),
            // ),
            // 直立的時候 : 就顯示 Chart 以及 TransactionList
            // 由於_buildPortraitContent回傳型態是List<Widget> 與期望的單一個Widget型態不符
            // 這邊的解決方式是加上... 意思是告訴Dart將List<Widget>自動拆散於<Widget>[]陣列之中
            if (!isLandscape)
              ..._buildPortraitContent(chartHeight, txListWidget),
            // if (!isLandscape) txListWidget,
            // 水平的時候 ： 顯示Switch去動態調整顯示 Chart 或 TransactionList
            // if (isLandscape)

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
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            // 增加判斷：如果是iOS則不顯示FloatingActionButton
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}

/**
 * 測驗12 : Widgets, Elements, build()
 * 可以複習138: Widgets tree, element tree, render object
 * question: What's the job of Widget tree ?
 * answer: Provide configuration for element and render tree.
 * 
 * question: What's the job of Element tree? (widget and render tree的中間層)
 * answer: Connect widget and render tree, manage state, update render tree when widget tree change.
 * 
 * question:What is correct about build()?
 * answer: build() runs very often and re-builds the widget tree (or part of it)
 * 
 * question: What's NOT a viable option for reducing the amount of widgets (including built-in widgets) affected by build()?
 * answer: Using only a single / a few widgets in the whole app
 * 以下這兩個則是viable option for reducing the amount of widgets
 * Splitting the app into multiple(small) custom widgets.
 * Using const widgets and constructors.
 */
