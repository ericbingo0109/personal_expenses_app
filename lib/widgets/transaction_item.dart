import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              // 這邊尺寸確定不會變且點進EdgeInsets的原始碼也是call const EdgeInsets.fromLTRB
              // 因此加上const
              padding: const EdgeInsets.all(6),
              child: FittedBox(child: Text('\$${transaction.amount}')),
            ),
          ),
          title: Text(
            transaction.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            DateFormat.yMMMMd().format(transaction.date),
          ),
          trailing: MediaQuery.of(context).size.width > 450
              ? FlatButton.icon(
                  //注意這邊要用 FlatButton.icon
                  icon: const Icon(Icons.delete),
                  // 這邊確定不會更改 所以加上const，因此再次build的時候直接抓記憶體裡面的值，可以優化一點點性能
                  label: const Text('Delete'),
                  color: Theme.of(context).errorColor,
                  onPressed: () => deleteTx(transaction.id),
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor, // default red
                  onPressed: () => deleteTx(transaction.id),
                )),
    );
  }
}
