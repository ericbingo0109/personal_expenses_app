import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  /* 另一種抓取user input 為使用TextEditingController*/
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              // onChanged: (value) { // 這邊可以自己命名傳入參數

              // this.titleInput = value;
              // },
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (value) => this.amountInput = value,
              controller: amountController,
            ), // 文字輸入框 輸入字的時候，labelText會上移縮小並不會消失
            FlatButton(
              onPressed: () {
                print(titleController.text);
                print(amountController.text);
              },
              //color: Colors.black,
              textColor: Colors.purple,
              child: Text('Add Transaction'),
              //hoverColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
