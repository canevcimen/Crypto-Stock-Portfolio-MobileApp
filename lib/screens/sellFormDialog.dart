import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/component/news_component.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/colors.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/constant.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';
import 'package:stock_investment_flutter/utils/images.dart';

import '../api/apiModel/item.dart';
import '../model/priceDetail.dart';
import '../model/sell.dart';
import '../model/user.dart';

class SellFormDialog extends StatefulWidget {
  User? user;
  String? coinId;

  SellFormDialog(this.coinId, this.user);
  @override
  _SellFormDialogState createState() => _SellFormDialogState(this.coinId, this.user);
}

class _SellFormDialogState extends State<SellFormDialog> {
  double quantity = 0;
  double price = 0;
  User? user;
  String? coinId;

  _SellFormDialogState(this.coinId, this.user);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sell Stocks'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                quantity = double.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                price = double.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(labelText: 'Price'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Perform sell operation with quantity and price values
            // Here you can add your logic for selling stocks
            print('Sell operation: Quantity=$quantity, Price=$price');
            Sell newSell = Sell.withoutId(this.user!.id, this.coinId, quantity, price, "2023-09-06 00:00:00");
            insertSell(newSell);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Sell'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}