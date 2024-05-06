import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsComponent extends StatelessWidget {
  final StockInvestModel data;

  NewsComponent(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonDecoration(),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          //CommonCachedNetworkImage(data.image, width: 40, height: 40, fit: BoxFit.cover),
          Image.network(getImage(data.image), width: 30, height: 30),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.title.validate(), style: boldTextStyle()),
              8.height,
              Row(
                children: [
                  Text(data.subTitle.validate(), style: boldTextStyle(color: Colors.red)),
                  8.width,
                  Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.red, boxShape: BoxShape.circle),
                    width: 6,
                    height: 6,
                  ),
                  8.width,
                  Text(dateFromTimestap(1685536218), style: secondaryTextStyle(size: 12)),
                ],
              ),
            ],
          ).expand()
        ],
      ),
    ).onTap((){
      _launchURL(data.url.toString());
    });
  }

  _launchURL(String _url) async {
   final Uri url = Uri.parse('https://flutter.dev');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $_url');
    }
}
  String dateFromTimestap(int time){
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int ts = time;
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String datetime = tsdate.year.toString() + "/" + tsdate.month.toString() + "/" + tsdate.day.toString();
    print(datetime); 
    return datetime;
  }
  
  String getImage(String? image) {
    if(image==null || image==""){
      return "https://t4.ftcdn.net/jpg/05/07/58/41/360_F_507584110_KNIfe7d3hUAEpraq10J7MCPmtny8EH7A.jpg";
    }else{
      return image;
    }
  }

}
