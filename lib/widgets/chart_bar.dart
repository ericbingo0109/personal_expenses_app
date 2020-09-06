import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPercentageOfTotal);

  /**
   * 測驗10
   * 問題：Where can you use device sizes fetched via MediaQuery?
   * 答案：In conditions or dynamically calculate sizes.
   * You can use the data to calculate sizes dynamically or control which widget is (not) display in which way.
   * 問題：What's the difference between MediaQuery and LayoutBuilder?
   * 答案： MediaQuery gives you device information, LayoutBuilder gives you constraints that apply to widgets.
   * 
   */
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                // 這邊設定chart僅顯示到整數部分
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              // 只是做個間隔
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              // 利用constraints.maxHeight去分配高度
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(220, 220, 220, 1), // light grey 淺灰色
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  /**
               * heightFactor 的值在 0 ~ 1 之間
               * 1 means 100% of the surrounding Container which is h:60 , w:10
               */
                  FractionallySizedBox(
                    heightFactor: spendingPercentageOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              // 只是做個間隔
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              // 當最後這個高度可能被壓縮很小而影響到Text大小的話
              // 用FittedBox automatically resized to still fit into that box
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
