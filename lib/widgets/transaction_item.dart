// 先放Dart 的package
import 'dart:math';
// 第三方的package
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// 自己的package放最後面
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  // final List<Transaction> transactions; 原本的回傳是list
  // 這邊改為回傳單一個 transactionItem
  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.purple,
    ];
    // 隨機產生非負整數，包含0到max(不包含), nextInt(4) 表示隨機從0, 1, 2, 3抓一個數字
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _bgColor,
            /**
             * 目前這樣寫會有bug: 當第一個item背景色是黑色而第二個item是藍色時，刪除掉第一個item後，
             * List的第二個item遞補上來成為第一個item，但是其背景色卻變成黑色了
             * 導致此問題的原因在第150的影片，簡要來說就是Widget tree刪除了但是element tree卻是刪除最後一個element的state
             */
            radius: 30,
            child: Padding(
              // 這邊尺寸確定不會變且點進EdgeInsets的原始碼也是call const EdgeInsets.fromLTRB
              // 因此加上const
              padding: const EdgeInsets.all(6),
              child: FittedBox(child: Text('\$${widget.transaction.amount}')),
            ),
          ),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMMd().format(widget.transaction.date),
          ),
          trailing: MediaQuery.of(context).size.width > 450
              ? FlatButton.icon(
                  //注意這邊要用 FlatButton.icon
                  icon: const Icon(Icons.delete),
                  // 這邊確定不會更改 所以加上const，因此再次build的時候直接抓記憶體裡面的值，可以優化一點點性能
                  label: const Text('Delete'),
                  color: Theme.of(context).errorColor,
                  onPressed: () => widget.deleteTx(widget.transaction.id),
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor, // default red
                  onPressed: () => widget.deleteTx(widget.transaction.id),
                )),
    );
  }
}
