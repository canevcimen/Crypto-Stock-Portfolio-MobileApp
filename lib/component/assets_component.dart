import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/common.dart';

import '../model/user.dart';
import '../screens/stock_detail_screen.dart';

class AssetsComponent extends StatelessWidget {
  final StockInvestModel data;
  User? user;
  AssetsComponent(this.data,this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonDecoration(),
      width: context.width(),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //paymentComponent(data.image.validate(), logo_color: data.imageBackground),
                   Image.network(getImage(data.image),width: 22, height: 22),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.title.validate(), style: boldTextStyle()),
                      8.height,
                      Text(data.subTitle.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(data.stockPrice.validate()),
                  8.height,
                  Text('Elde Adet', style: secondaryTextStyle()),
                ],
              )
            ],
          ),
          16.height,
          Divider(height: 0, color: appStore.isDarkModeOn ? dividerDarkColor : gray.withOpacity(0.1)),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Portfolio Value', style: secondaryTextStyle()),
                  8.height,
                  Text(data.stockScale.validate(), style: boldTextStyle()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Profit', style: secondaryTextStyle()),
                  8.height,
                  Text(data.profit.validate(), style: boldTextStyle(color: data.priceColor)),
                ],
              )
            ],
          ),
        ],
      ),
    ).onTap((){
      StockDetailScreen(this.data, this.user).launch(context);
    });
  }

  String getImage(String? image) {
    if(image==null || image==""){
      return "https://t4.ftcdn.net/jpg/05/07/58/41/360_F_507584110_KNIfe7d3hUAEpraq10J7MCPmtny8EH7A.jpg";
    }else{
      return image;
    }
  }
}
