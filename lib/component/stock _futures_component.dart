import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/images.dart';
import 'package:stock_investment_flutter/screens/stock_detail_screen.dart';

import '../model/user.dart';
//big mc data component
class StockFuturesComponent extends StatelessWidget {
  final StockInvestModel data;
  User? user;
  StockFuturesComponent(this.data,this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonDecoration(),
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //paymentComponent(data.image.validate(), logo_color: data.imageBackground),
              Image.network(getImage(data.image),width: 22, height: 22),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title.validate(), style: boldTextStyle()),
                  4.height,
                  Text(data.subTitle.validate(), style: secondaryTextStyle()),
                ],
              ),
            ],
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.stockPrice.validate(), style: boldTextStyle(size: 20)),
                  8.height,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        margin: EdgeInsets.only(right: 4),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor:getColor(data.priceColor),// Colors.green,
                          border: Border.all(color: white),
                        ),
                        child: data.icon,
                      ),
                      Text(data.stockScale.validate(), style: primaryTextStyle(color: data.priceColor)),
                    ],
                  ),
                ],
              ),
              CommonCachedNetworkImage(graph, color: context.iconColor, fit: BoxFit.cover, height: 30, width: 60)
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
  
  getColor(Color? priceColor) {
    return priceColor;
  }

  
}
