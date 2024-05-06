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
import '../model/buy.dart';
import '../model/priceDetail.dart';
import '../model/user.dart';




class BuyFormDialog extends StatefulWidget {
  User? user;
  String? coinId;

  BuyFormDialog(this.coinId, this.user);

  @override
  _BuyFormDialogState createState() => _BuyFormDialogState(this.coinId, this.user);
}

class _BuyFormDialogState extends State<BuyFormDialog> {
  double quantity = 0;
  double price = 0;
  User? user;
  String? coinId;

  _BuyFormDialogState(this.coinId, this.user);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Buy Stocks'),
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
            // Perform buy operation with quantity and price values
            // Here you can add your logic for buying stocks
            Buy newBuy = Buy.withoutId(this.user!.id,this.coinId,quantity,price,"2023-06-09 00:15:10");
            insertBuy(newBuy);

            print('Buy operation: Quantity=$quantity, Price=$price');
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Buy'),
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