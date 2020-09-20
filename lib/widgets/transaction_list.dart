import 'package:flutter/material.dart';
import './transaction_item.dart';
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
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transaction add yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    // 常用來當作Widget之間的間隔
                    height: 10,
                  ),
                  Container(
                    height:
                        constraints.maxHeight * 0.6, // 讓圖片高度動態 fix 避免overflow
                    child: Image.asset(
                      'assets/images/waiting.png',
                      // 建議用container  wrap Image
                      // BoxFit.cover is a great option that respects the boundaries of the surrounding "container" and fits image
                      fit: BoxFit.cover, // 延伸填滿(圖片可能會被過度放大，部分被裁減掉)
                    ),
                  )
                ],
              );
            },
          )
        // 注意：ListView是無限高度 所以上面才用container包住並且限制高度
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      // 為每個 TransactionItem 產生 UniqueKey但這方法沒用，每次重build的時候顏色又變了
                      // 且在彈出輸入資料的視窗時，就可看到顏色變了
                      // key: UniqueKey(),
                      /**
                       * UniqueKey & ValueKey 差別：
                       * Unlike UniqueKey(), ValueKey() does not (re-)calculate a random value 
                       * but simply wraps a non-changing identifier provided by you
                       */
                      key: ValueKey(tx.id), //可解決上述問題，且刪除時也維持原本item的顏色
                      // 使用key 讓flutter element對應widget
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
          );
  }
}
