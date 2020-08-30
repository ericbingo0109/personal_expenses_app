import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:keyboard_actions/keyboard_actions.dart';
// import '../widgets/user_transactions.dart';

class NewTransaction extends StatefulWidget {
  /* 另一種抓取user input 為使用TextEditingController*/
  final Function addTx;
  NewTransaction({this.addTx});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate; // 選定date後可能會變動 所以不用final

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    // 在這邊做簡單的輸入值檢查，其中有一欄位為空則return 不讓user submit
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop(); // 當程式流程走到這裡時，自動將popup的視窗關閉
  }

  void _presentDatePicker() {
    // Flutter 內建 showDatePicker
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // after user pick a Date
      if (pickedDate == null) {
        return;
      }
      // 別忘了要setState 才會再build一次
      setState(() {
        _selectedDate = pickedDate;
        print(DateFormat.yMd().format(_selectedDate));
      });
    });
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
              controller: _titleController,
              // onSubmitted: (value) => _submitData,
              // 也可以這樣寫，底線代表I get an argument, but I don't care about it here
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              // onChanged: (value) => this.amountInput = value,
              controller: _amountController,
              keyboardType: TextInputType.number, // cursor在此欄位時僅跳出數字keyboard
              // On iOS, this might not allow for decial places. 如果在ios彈起的鍵盤中無小數點符號
              // 就用 keyboardType: TextInputType.numberWithOptions(decimal: true) 來解決此問題
              // keyboardType: TextInputType.numberWithOptions(decimal: true),
              // FIXME:這邊ios有個問題就是不會自動彈出輸入鍵盤...google了半天找不到解決方式
              // onSubmitted: (value) => _submitData,
              // 也可以這樣寫，底線代表I get an argument, but I don't care about it here
              onSubmitted: (_) => _submitData(),
            ), // 文字輸入框 輸入字的時候，labelText會上移縮小並不會消失
            Container(
              height: 80,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Chose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _presentDatePicker, // just pass the reference
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: _submitData,
              color: Theme.of(context).primaryColor,
              // 在main.dart 設定button color
              textColor: Theme.of(context).textTheme.button.color,
              child: Text('Add Transaction'),
              //hoverColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
