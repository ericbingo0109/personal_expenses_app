import 'package:flutter/material.dart';
// import 'package:keyboard_actions/keyboard_actions.dart';
// import '../widgets/user_transactions.dart';

class NewTransaction extends StatelessWidget {
  /* 另一種抓取user input 為使用TextEditingController*/
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  // 將user_transactions的_addNewTransaction 的pointer綁到addTx
  // 這樣就能在這檔案執行那個private function了
  final Function addTx;
  NewTransaction({this.addTx});

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    // 在這邊做簡單的輸入值檢查，其中有一欄位為空則return 不讓user submit
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    addTx(
      enteredTitle,
      enteredAmount,
    );
  }

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
              // onSubmitted: (value) => submitData,
              // 也可以這樣寫，底線代表I get an argument, but I don't care about it here
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (value) => this.amountInput = value,
              controller: amountController,
              // keyboardType: TextInputType.number, // cursor在此欄位時僅跳出數字keyboard
              // On iOS, this might not allow for decial places. 如果在ios彈起的鍵盤中無小數點符號
              // 就用 keyboardType: TextInputType.numberWithOptions(decimal: true) 來解決此問題
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              // FIXME:這邊ios有個問題就是不會自動彈出輸入鍵盤...google了半天找不到解決方式
              // onSubmitted: (value) => submitData,
              // 也可以這樣寫，底線代表I get an argument, but I don't care about it here
              onSubmitted: (_) => submitData(),
            ), // 文字輸入框 輸入字的時候，labelText會上移縮小並不會消失
            FlatButton(
              onPressed: submitData,
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
