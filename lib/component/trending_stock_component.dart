import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/common.dart';

import '../model/user.dart';
import '../screens/stock_detail_screen.dart';

class TrendingStockComponent extends StatelessWidget {
  final StockInvestModel data;
  User? user;

  TrendingStockComponent(this.data, this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: commonDecoration(),
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //paymentComponent(data.image.toString(), logo_color: data.imageBackground),
            Image.network(getImage(data.image),width: 22, height: 22),
            16.height,
            Text(data.title.toString(), style: boldTextStyle()),8.height,
            Row(
              children: [
                Text("Market Cap Rank", style: secondaryTextStyle()),
                16.width,
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
                      child: data.icon,
                    ),
                    Text(data.market_cap_rank.toString(), style: primaryTextStyle(color: Colors.green)),
                  ],
                ),
              ],
            ),
          ],
        )).onTap((){
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
