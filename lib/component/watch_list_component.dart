import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/screens/stock_detail_screen.dart';
import 'package:stock_investment_flutter/utils/common.dart';

import '../model/user.dart';

class WatchListComponent extends StatelessWidget {
  final StockInvestModel data;
  User? user;
  WatchListComponent(this.data,this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: appStore.isDarkModeOn ? cardDarkColor : gray.withOpacity(0.1),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
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
          ).expand(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.stockPrice.validate(), style: boldTextStyle(color: data.priceColor!)),
              8.height,
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(right: 4),
                    decoration: boxDecorationWithRoundedCorners(
                      boxShape: BoxShape.circle,
                      backgroundColor: data.priceColor!,
                      border: Border.all(color: white),
                    ),
                    child: data.icon.validate(),
                  ),
                  Text(data.stockScale.validate(), style: primaryTextStyle(color: data.priceColor)),
                ],
              ),
            ],
          ),
        ],
      ),
    ).onTap((){
      //StockDetailScreen(this.data, User(1, "emrulalh", "emrullah@gmail.com", "1", "x", "x")).launch(context);
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>StockDetailScreen(this.data, this.user)),
                );
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
