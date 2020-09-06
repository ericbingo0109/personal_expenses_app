import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    /**
     * 參考 https://stackoverflow.com/questions/55261399/flutter-how-to-fix-a-renderflex-overflowed-by-pixels-error/55261726
     * 以Expanded 包覆原本的Container  來修正以下問題:
     * The following assertion was thrown during layout:
     * I/flutter (23294): A RenderFlex overflowed by 2.9 pixels on the bottom.
     * I/flutter (23294): The relevant error-causing widget was:
I/flutter (23294):   Column file:///Users/eric/development/UdemyFlutterCourse/personal_expenses_app/lib/main.dart:87:13
I/flutter (23294): 
I/flutter (23294): The overflowing RenderFlex has an orientation of Axis.vertical.
     */
    // return Expanded(
    //   child: Container(
    // 為了測試MediaQuery的效果 先暫時不用Expanded包覆Container
    // height: 300, //記得要限制個高度給 ListView
    /**
         * ListView(children: [])
         * ListView.builder() // 這種只會load螢幕上可見到的範圍  Only load what visible!
         * 當List很多elements時 使用ListView.builder() 會有較佳的performance
         */
    // child: transactions.isEmpty
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              Text(
                'No transaction add yet!',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                // 常用來當作Widget之間的間隔
                height: 10,
              ),
              Container(
                height: 200,
                child: Image.asset(
                  'assets/images/waiting.png',
                  // 建議用container  wrap Image
                  // BoxFit.cover is a great option that respects the boundaries of the surrounding "container" and fits image
                  fit: BoxFit.cover, // 延伸填滿(圖片可能會被過度放大，部分被裁減掉)
                ),
              )
            ],
          )
        // 注意：ListView是無限高度 所以上面才用container包住並且限制高度
        : ListView.builder(
            itemBuilder: (context, index) {
              // 改用ListTile
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor, // default red
                      onPressed: () => deleteTx(transactions[index].id),
                    )),
              );
              /*
                  return Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            // tx.amount.toString(),
                            // toStringAsFixed(2) 固定輸出字串到小數點後2位 四捨五入
                            '\$${transactions[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                // color: Colors.red),
                                color: Theme.of(context).primaryColor),
                          ),
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.red, width: 2)),
                              // 如下設定 這樣顏色就會如同在main.dart設定全域的theme顏色相同了
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          padding: EdgeInsets.all(10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              transactions[index].title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              // DateFormat().format(tx.date),// August 16, 2020 7:17:03 PM
                              // DateFormat('yyyy-MM-dd').format(tx.date),// 2020-08-16
                              // 注意下面這個小時要用大寫HH為24小時制，反之hh則為12小時制
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                  transactions[index]
                                      .date), // 2020-08-16 19:18:30
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              /**
                                   * 更多時間的example 看 第82講
                                   * 或直接去看文件說明https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
                                   */
                              DateFormat.yMMMd().format(
                                  transactions[index].date), // Aug 16, 2020
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                  //將原本的Card 放在itemBuilder內
                  // 也取代了原先transactions.map((tx) {...}).toList(),的方式
                  */
            },
            itemCount: transactions.length, // how many items should be build
          );
    // ),
    // );
  }
}
