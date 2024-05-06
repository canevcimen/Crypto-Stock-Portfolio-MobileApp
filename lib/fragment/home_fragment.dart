import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/component/news_component.dart';
import 'package:stock_investment_flutter/component/trending_stock_component.dart';
import 'package:stock_investment_flutter/component/watch_list_component.dart';
import 'package:stock_investment_flutter/fragment/all_news_fragment.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/screens/shimmer_home_screen.dart';
import 'package:stock_investment_flutter/utils/colors.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/constant.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';
import 'package:stock_investment_flutter/utils/images.dart';
import 'package:stock_investment_flutter/utils/shimmer/shimmer.dart';

import '../model/portfolio.dart';
import '../model/user.dart';

class HomeFragment extends StatefulWidget {
  User user=new User.withoutAnyInfo();

  HomeFragment(User user){
    this.user = user;
  }
  @override
  _HomeFragmentState createState() => _HomeFragmentState(this.user);

}

class _HomeFragmentState extends State<HomeFragment> {
  List<StockInvestModel> watchData = [];//watchList();
  List<StockInvestModel> trendingStockData = []; 
  List<StockInvestModel> stockNewsData = [];
  bool isActive = true;
  User? user;
  double totalAssertValue =0.0;
  List<String> assetImages = [];

  _HomeFragmentState(User user){
    this.user=user;
  }

  @override
  void initState() {
    super.initState();
    isActive = true;
    init();
  }

  void init() async {
    setStatusBarColor(primaryColor, delayInMilliSeconds: 300);
    setTrendingStockData();
    setwatchData();
    setstockNewsData();
    setTotalAssertValue(user);
    setState(() {
      isActive = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appBarWidget("", color: primaryColor);
    return Scaffold(
      body: isActive
          ? SizedBox(
              child: Shimmer.fromColors(
                baseColor: appStore.isDarkModeOn ? Colors.black12 : Colors.grey[400],
                highlightColor: appStore.isDarkModeOn ? Colors.white12 : Colors.grey[100],
                period: Duration(milliseconds: 1000),
                child: ShimmerHomeScreen(),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  42.height,
                  Container(
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: BorderRadius.zero),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Hi, ${user!.fullname}', style: boldTextStyle(color: white)),
                                    8.width,
                                    CommonCachedNetworkImage(ic_hello, height: 20, width: 20, fit: BoxFit.cover),
                                  ],
                                ),
                                8.height,
                                Text('Welcome back to Stock!', style: secondaryTextStyle(color: white.withOpacity(0.5))),
                              ],
                            ).expand(),
                            GestureDetector(
                              onTap: () {
                                toast("Notification");
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: boxDecorationWithRoundedCorners(
                                  border: Border.all(color: appStore.isDarkModeOn ? white : gray.withOpacity(0.4)),
                                  boxShape: BoxShape.circle,
                                  backgroundColor: primaryColor,
                                ),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Icon(Icons.notifications_none, size: 22, color: Colors.white),
                                    Container(
                                      margin: EdgeInsets.only(right: 2, top: 3),
                                      decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.red),
                                      width: 6,
                                      height: 6,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        16.height,
                        Container(
                          padding: EdgeInsets.all(24),
                          width: context.width(),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green.withOpacity(0.8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total assert value', style: secondaryTextStyle(color: white.withOpacity(0.6))),
                              8.height,
                              Row(
                                children: [
                                  Text('\$$totalAssertValue', style: boldTextStyle(color: white, size: 22)),
                                  4.width,
                                  CommonCachedNetworkImage(ic_show, height: 12, width: 12, color: white.withOpacity(0.4)),
                                ],
                              ),
                              8.height,
                              Row(
                                children: [
                                  
                                  
                                ],
                              ),
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children:[
                                      ...getAssetImageNetwork(),
                                      16.width,
                                      /*
                                      paymentComponent(amazon_logo),
                                      Positioned(right: -24, child: paymentComponent(whatsapp_logo, logo_color: Colors.black)),
                                      Positioned(right: -48, child: paymentComponent(zoom_logo, logo_color: sandyBrown)),*/
                                    ],
                                  ),
                                  16.width,
                                  CommonCachedNetworkImage(graph, color: white, fit: BoxFit.cover, height: 30, width: 60)
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.height,
                        /*

                        Row(
                          children: [
                            AppButton(
                              color: appStore.isDarkModeOn ? cardDarkColor : gray.withOpacity(0.4),
                              onTap: () {
                                //
                              },
                              elevation: 0.0,
                              width: context.width(),
                              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.only(right: 4),
                                    decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: Colors.transparent,
                                      border: Border.all(color: white),
                                    ),
                                    child: Icon(Icons.keyboard_arrow_up, size: 16, color: white),
                                  ),
                                  8.width,
                                  Text('Deposit', style: boldTextStyle(color: white)),
                                ],
                              ),
                            ).expand(),
                            16.width,
                            OutlinedButton(
                              onPressed: () {
                                //
                              },
                              style: OutlinedButton.styleFrom(
                                onSurface: Colors.white, //<-- SEE HERE
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.only(right: 4),
                                    decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      backgroundColor: Colors.transparent,
                                      border: Border.all(color: white),
                                    ),
                                    child: Icon(Icons.download_outlined, size: 16, color: white),
                                  ),
                                  8.width,
                                  Text('Withdraw', style: boldTextStyle(color: white)),
                                ],
                              ),
                            ).expand(),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Watchlist', style: boldTextStyle(size: headingTextSize)),
                          TextButton(
                            onPressed: () {
                              //
                            },
                            child: Text('Edit Watchlist', style: secondaryTextStyle()),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: watchData.length,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (_, index) => WatchListComponent(watchData[index],this.user).paddingOnly(bottom: 16),
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      Text('Trending Stock', style: boldTextStyle(size: headingTextSize)).paddingOnly(left: 16, bottom: 16),
                      HorizontalList(
                        itemCount: trendingStockData.length,
                        padding: EdgeInsets.all(16),
                        spacing: 8,
                        runSpacing: 16,
                        itemBuilder: (_, index) => TrendingStockComponent(trendingStockData[index],this.user).paddingOnly(right: 8),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor),
                        child: CommonCachedNetworkImage(dashboard, fit: BoxFit.cover, height: 150, width: context.width()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('News', style: boldTextStyle(size: headingTextSize)),
                          TextButton(
                            onPressed: () {
                              AllNewsFragment(showBackIcon: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                            child: Text('View All', style: secondaryTextStyle(size: 14, color: appStore.isDarkModeOn ? white : gray)).visible(stockNewsData.length >= 4),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stockNewsData.take(4).length,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (_, index) => NewsComponent(stockNewsData[index]).paddingOnly(bottom: 16),
                      ).paddingSymmetric(horizontal: 16),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> setTrendingStockData() async {
    List<StockInvestModel> temp= await trendingStockList();
    setState(() {
      this.trendingStockData = temp;
    });
  }
  
  Future<void> setwatchData()async {
    List<StockInvestModel> temp = await watchList(this.user!.id);
    setState(() {
      this.watchData = temp;
    });

  }
  
  Future<void> setstockNewsData() async {
    List<StockInvestModel> temp = await stockNewsList();
    setState(() {
      this.stockNewsData = temp;
    });
  }
  
  

   Future<void> setTotalAssertValue(User? user) async {
    List<Portfolio> temp = await assertsList(user);
    setState(() {
      
      for(Portfolio portfolio in temp){
       
        totalAssertValue+= portfolio.portfolioValue!.toDouble();
        assetImages.add(portfolio.image.toString());
      }
      print(totalAssertValue);
    });

  }


  List<Positioned> getAssetImageNetwork(){
    List<Positioned> list =List<Positioned>.empty(growable: true);
    for(int i=0; i<assetImages.length; i++){
      
      //eğer ilk resimse
      list.add(Positioned(right: (-24*i).toDouble(), child: Image.network(getImage(assetImages.elementAt(i)),width: 22, height: 22)));
      
    }
    return list;
  }

  String getImage(String? image) {
    if(image==null || image==""){
      return "https://t4.ftcdn.net/jpg/05/07/58/41/360_F_507584110_KNIfe7d3hUAEpraq10J7MCPmtny8EH7A.jpg";
    }else{
      return image;
    }
  }

}
