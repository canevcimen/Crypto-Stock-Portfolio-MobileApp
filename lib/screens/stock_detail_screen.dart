import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/component/news_component.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/screens/sellFormDialog.dart';
import 'package:stock_investment_flutter/utils/colors.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/constant.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';
import 'package:stock_investment_flutter/utils/images.dart';

import '../api/apiModel/item.dart';
import '../model/priceDetail.dart';
import '../model/user.dart';
import 'buyFormDialog.dart';
import 'package:stock_investment_flutter/utils/colors.dart';

class StockDetailScreen extends StatefulWidget {
  final StockInvestModel data;
  User? user;

  StockDetailScreen(this.data, this.user);
  
  @override
  _StockDetailScreenState createState() => _StockDetailScreenState(this.data, this.user);
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  List<String> data = ['Overview', 'History'];
  List<String> selectedData = ['24H', '7D', '1M', '3M', '1Y', 'ALL'];

  double maxY=0; //price
  double minY=0;
  int minX=0;   //timestap
  int maxX=0;

  StockInvestModel investModel;
  User? user;
  _StockDetailScreenState(this.investModel, this.user);

  int selectedIndex = 0;
  int selectedStockIndex = 0;

  //open bid ask gibi alttaki detay
  List<StockInvestModel> stockPrice = [];
  List<StockInvestModel> displayedStockPrices=[];
  Item? item;

  List<StockInvestModel> stockNewsData = fakestockNewsList(); //kullanılmıypor salla

  List<Color> gradientColor = [lineCChart, lineCChart1];

  //ekrana çizilen fiyatchart'ı
  List<FlSpot> newList = [];

  
  void initstate() {
    super.initState();
    print("init starting");
    init();
  }

  void init() async {
    print("init method starting");
    setStatusBarColor(primaryColor);
    print("setStatusBarColor called");
    setItem();
    await setPriceList(this.investModel.id.toString(), "1");
    print("setPriceList called");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            leading: IconButton(
              onPressed: () {
                finish(context);
              },
              icon: Icon(Icons.arrow_back_outlined, color: white),
            ),
            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: () {
                  toast("Ratting");
                },
                icon: Icon(Icons.star, color: Colors.yellow, size: 26),
              ),
              IconButton(
                  onPressed: () {
                    toast("Notification");
                  },
                  icon: Icon(Icons.notifications_none, color: white, size: 26)),
              IconButton(onPressed: () {
                print("SETTİNG THE DATA");
                setPriceList(this.investModel.id.toString(), "1");
                setItem();
                this.stockPrice = stockPriceList();
              }, icon: Icon(Icons.upload_outlined, color: white, size: 26))
            ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: BorderRadius.zero),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: gray.withOpacity(0.4)),
                      width: context.width(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                
                                child:Image.network(this.item?.small==null? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXcETXueRkt0LVJJAtiRNYhf3pnj6rFEAiGFlxBeSo&s" : this.item!.small.toString(), width: 50, height: 50), //CommonCachedNetworkImage(amd_stock, color: white, fit: BoxFit.cover, width: 50, height: 50),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(this.item?.symbol==null? "TEMP" : this.item!.symbol.toString(), style: boldTextStyle(color: white)),
                                  8.height,
                                  Text(this.item?.name==null? "TEMP" : this.item!.name.toString(), style: secondaryTextStyle(color: white.withOpacity(0.5))),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(this.item?.current_price==null? "0.00" : this.item!.current_price.toString(), style: boldTextStyle(color: white)),
                              12.height,
                              Row(
                                children: [
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: gray,
                                    ),
                                    child: getIcon(),
                                  ),
                                  8.width,
                                  Text(this.item?.price_change_percentage_24h==null? "0%" : this.item!.price_change_percentage_24h.toString(), style: secondaryTextStyle(color: white.withOpacity(0.5))),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    16.height,
                    //GRAFİK ÇİZİMİ
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        16.height,
                        Container(
                          padding: EdgeInsets.only(right: 16),
                          height: 350,
                          width: context.width(),
                          child: LineChart(
                            LineChartData(
                              minX: this.minX.toDouble(),
                              maxX: this.maxX.toDouble(),
                              minY: this.minY,
                              maxY: this.maxY,
                              titlesData: LineTitles.getTitleData(this.maxY, this.minY, this.maxX, this.minX),
                              gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: borderText.withOpacity(0.3),
                                      strokeWidth: 0.2,
                                    );
                                  },
                                  drawVerticalLine: true),
                              borderData: FlBorderData(border: Border.all(color: borderText, width: 0.1)),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: newList,
                                  isCurved: true,
                                  color: greenColor,
                                  barWidth: 3,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: gradientColor[0].withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //24h 7d 
                        HorizontalList(
                          itemCount: selectedData.length,
                          padding: EdgeInsets.all(16),
                          spacing: 8,
                          runSpacing: 16,
                          itemBuilder: (_, index) => Container(
                            decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: selectedStockIndex == index
                                  ? appStore.isDarkModeOn
                                      ? cardDarkColor
                                      : white
                                  : Colors.transparent,
                              border: Border.all(color: selectedStockIndex == index ? Colors.transparent : gray.withOpacity(0.1)),
                            ),
                            margin: EdgeInsets.only(right: 8),
                            child: Text(
                              selectedData[index],
                              style: boldTextStyle(
                                color: selectedStockIndex == index
                                    ? appStore.isDarkModeOn
                                        ? white
                                        : black
                                    : white,
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                          ).onTap(() {
                            setState(() {
                              selectedStockIndex = index;
                            });

                            if (index == 0) {
                              
                              setPriceList(this.investModel.id.toString(),"1");
                              setItem();
                            } else if (index == 1) {
                              setPriceList(this.investModel.id.toString(),"7");
                            } else if (index == 2) {
                              setPriceList(this.investModel.id.toString(),"30");
                            } else if (index == 3) {
                              setPriceList(this.investModel.id.toString(),"90");
                            } else if (index == 4) {
                              setPriceList(this.investModel.id.toString(),"360");
                            } else if (index == 5) {
                              setPriceList(this.investModel.id.toString(),"max");
                            }
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //overwier statics 
              HorizontalList(
                itemCount: data.length,
                padding: EdgeInsets.all(16),
                spacing: 8,
                runSpacing: 16,
                itemBuilder: (_, index) => Container(
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: selectedIndex == index
                        ? Colors.yellow
                        : appStore.isDarkModeOn
                            ? dividerDarkColor
                            : white,
                    border: Border.all(color: selectedIndex == index ? Colors.transparent : gray.withOpacity(0.1)),
                  ),
                  margin: EdgeInsets.only(right: 8),
                  child: Text(
                    data[index],
                    style: boldTextStyle(
                      color: selectedIndex == index
                          ? black
                          : appStore.isDarkModeOn
                              ? white
                              : black,
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                ).onTap(() {
                  setState(() {
                    selectedIndex = index;
                  });
                }),
              ),
             //close open infos
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(color: appStore.isDarkModeOn ? white : gray.withOpacity(0.2)),
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayedStockPrices.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (_, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(displayedStockPrices[index].title.validate(), style: secondaryTextStyle()),
                    Text(displayedStockPrices[index].stockPrice.validate(), style: boldTextStyle()),
                  ],
                ).paddingSymmetric(vertical: 8),
              ),
              SizedBox(
                width: context.width(),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      this.displayedStockPrices = stockPrice;
                    });
                    //
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 28, 74, 82),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text('Show All', style: boldTextStyle(color: Colors.white)),
                ),
                
              ).paddingSymmetric(horizontal: 16, vertical: 8),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                  onPressed: () {
                    print("buy click");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BuyFormDialog(this.investModel.id, this.user);
                      },
                    );
                   
                  },
                  style: OutlinedButton.styleFrom(
                    //backgroundColor: Color.fromARGB(255, 28, 74, 82),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text('Buy', style: boldTextStyle(color: Colors.white)),
                ),
                SizedBox(width: 16,),
                OutlinedButton(
                  onPressed: () {
                    //
                     showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SellFormDialog(this.investModel.id, this.user);
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    //backgroundColor: Color.fromARGB(255, 28, 74, 82),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text('Sell', style: boldTextStyle(color: Colors.white)),
                ),
                
                ],
              ),
             /* SizedBox(width: context.width(),
                child: OutlinedButton(
                  onPressed: () {
                    //
                  },
                  style: OutlinedButton.styleFrom(
                    onSurface: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text('Buy', style: boldTextStyle()),
                ),
                ).paddingSymmetric(horizontal: 40, vertical: 8),
              16.height,*/
              Text(''/*LATEST NEWS*/ , style: boldTextStyle(size: headingTextSize)).paddingOnly(left: 16),
              16.height,
              ListView.builder(
                shrinkWrap: true,
                itemCount: 0, //haber sayısı girileblir length
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (_, index) => NewsComponent(stockNewsData[index % stockNewsData.length]).paddingOnly(bottom: 16),
              ),
            ],
            
          ),
        ),
      ),
    );
  }
  
  Future setPriceList(String coin_id, String days, [String? interval]) async {
   PriceDetail priceDetail= await marketChartList(coin_id,days,interval);
   setState(() {
    this.newList = priceDetail.priceItems;
    this.maxY = priceDetail.maxY!.toDouble();
    this.minY = priceDetail.minY!.toDouble();
    this.maxX = priceDetail.maxX!.toInt();
    this.minX = priceDetail.minX!.toInt();
    print("min price " + minY.toString());
    print("max price " + maxY.toString());
   });

  }

  Future<void> setItem() async {
    Item temp = await detailedCoin(this.investModel.id.toString());
    setState(() {
      this.item = temp;
      print(this.item!.name);
    });
  }

  getIcon(){
    if(this.item?.price_change_percentage_24h==null){
      return Icon(Icons.error, color: Colors.red);
    }else{
      if(this.item!.price_change_percentage_24h!<0){
        return Icon(Icons.keyboard_arrow_down_sharp, color: Colors.red);
      }else{
        return Icon(Icons.keyboard_arrow_up_sharp, color: Colors.green);
      }
      
    }

  }

List<StockInvestModel> stockPriceList() {
  List<StockInvestModel> stockPriceData = [];

  stockPriceData.add(StockInvestModel(title: "ath", stockPrice: this.item?.ath.toString()));
  stockPriceData.add(StockInvestModel(title: "atl", stockPrice: this.item?.atl.toString()));
  stockPriceData.add(StockInvestModel(title: "high 24", stockPrice: this.item?.high_24h.toString()));
  stockPriceData.add(StockInvestModel(title: "low 24", stockPrice: this.item?.low_24h.toString()));
  stockPriceData.add(StockInvestModel(title: "market_cap_rank", stockPrice: this.item?.market_cap_rank.toString()));
  stockPriceData.add(StockInvestModel(title: "marketCap", stockPrice: this.item?.marketCap.toString()));
  stockPriceData.add(StockInvestModel(title: "price change percentage 7d", stockPrice: this.item?.price_change_percentage_7d.toString()));
  stockPriceData.add(StockInvestModel(title: "price change percentage 30d", stockPrice: this.item?.price_change_percentage_30d.toString()));
  stockPriceData.add(StockInvestModel(title: "price change percentage 60d", stockPrice: this.item?.price_change_percentage_60d.toString()));
  stockPriceData.add(StockInvestModel(title: "price change percentage 200d", stockPrice: this.item?.price_change_percentage_200d.toString()));
  stockPriceData.add(StockInvestModel(title: "price change percentage 1year", stockPrice: this.item?.price_change_percentage_1y.toString()));
  displayedStockPrices = stockPriceData.take(4).toList();
  return stockPriceData;
}

}

class LineTitles {
  static getTitleData(double maxY, double minY, int maxX, int minX) => FlTitlesData(
    leftTitles: AxisTitles(
      sideTitles: true,
      textStyle: primaryTextStyle(color: white.withOpacity(0.5)),
      getTitles: (value) {
        // Sol başlıkların mantığı
      },
      reservedSize: 35,
    ),
    show: true,
    bottomTitles: AxisTitles(
      getTextStyles: (context, value) => boldTextStyle(color: white.withOpacity(0.5)),
      showTitles: true,
      margin: 24,
      reservedSize: 38,
      getTitles: (value) {
        // Alt başlıkların mantığı
      },
    ),
  );
}
