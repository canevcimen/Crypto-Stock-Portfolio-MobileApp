import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/component/assets_component.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/constant.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';
import 'package:stock_investment_flutter/utils/images.dart';

import '../model/portfolio.dart';
import '../model/user.dart';

class PortfolioFragment extends StatefulWidget {
  User user=new User.withoutAnyInfo();

  PortfolioFragment(User user){
    this.user = user;
  }
  @override
  _PortfolioFragmentState createState() => _PortfolioFragmentState(this.user);
}

class _PortfolioFragmentState extends State<PortfolioFragment> {
  List<StockInvestModel> assertsData = [];
  List<Portfolio> portfolioItems = [];
  double totalportfolioValue=0.0;

  TextEditingController passwordCont = TextEditingController(text: "\$18,908.00");
  User? user;

  _PortfolioFragmentState(User user){
    this.user=user;
  }
  @override
  void initState() {
    super.initState();
    init();
    print("portfolio page");
    print("welcome "+ user!.fullname.toString());
    setPortfolioItems(user);
  }

  void init() async {
    setStatusBarColor(appStore.isDarkModeOn ? black : white);
    
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: "Portfolio",
        changeIcon: true,
        showLeadingIcon: false,
        iconWidget1: IconButton(
          onPressed: () {
            //
          },
          icon: Icon(Icons.filter_list, color: context.iconColor, size: 22),
        ),
        iconWidget2: IconButton(
          onPressed: () {
            //
          },
          icon: Icon(Icons.bookmarks_outlined, color: context.iconColor, size: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portfolio Balance', style: secondaryTextStyle()),
            16.height,
            SizedBox(
              width: 300,
              child: AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: passwordCont,
                textStyle: boldTextStyle(size: 22),
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 16).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 16).paddingAll(14),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
                  alignLabelWithHint: true,
                  enabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: context.scaffoldBackgroundColor,
                ),
              ),
            ),
            16.height,
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(right: 4),
                  decoration: boxDecorationWithRoundedCorners(
                    boxShape: BoxShape.circle,
                    backgroundColor: Colors.red,
                    border: Border.all(color: white),
                  ),
                  child: Icon(Icons.add, color: white, size: 14),
                ),
                Row(
                  children: [
                    Text("4.48% (+0.20%)", style: primaryTextStyle(color: Colors.red)),
                    8.width,
                    Text(' vs Last Week    ', style: secondaryTextStyle()),
                  ],
                ),
              ],
            ),
            24.height,
            Container(
              decoration: commonDecoration(),
              width: context.width(),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  portfolioType(image: ic_buy, portfolioTitle: "Buy/Sell").expand(),
                  Container(color: gray.withOpacity(0.3), height: 45, width: 1),
                  portfolioType(image: ic_transfer, portfolioTitle: "Transfer").expand(),
                  Container(color: gray.withOpacity(0.3), height: 45, width: 1),
                  portfolioType(image: ic_exchange, portfolioTitle: "Exchange").expand(),
                ],
              ),
            ),
            32.height,
            Text('Your Assets', style: boldTextStyle(size: headingTextSize)),
            32.height,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: assertsData.length,
              padding: EdgeInsets.all(0),
              itemBuilder: (_, index) => AssetsComponent(assertsData[index],this.user).paddingOnly(bottom: 16),
            ),
          ],
        ).paddingAll(16),
      ),
    );
  }
  
  Future<void> setPortfolioItems(User? user) async {
    List<Portfolio> temp = await assertsList(user);
    setState(() {
      this.portfolioItems = temp;
      for(Portfolio portfolio in portfolioItems){
        /*
        print("coin id " + portfolio.coinId.toString());
         print("coin image " + portfolio.image.toString());
         print("coin portfolioValue " + portfolio.portfolioValue.toString());
         print("coin profit " + portfolio.profit.toString());*/
         assertsData.add(StockInvestModel(id:portfolio.coinId,imageBackground: pink, image: portfolio.image, title: portfolio.symbol, subTitle: portfolio.name, stockPrice: portfolio.piece.toString(), stockScale: portfolio.portfolioValue.toString(), priceColor: getpriceColor(portfolio.profit!.toDouble()), profit: portfolio.profit.toString()));
        totalportfolioValue+= portfolio.portfolioValue!.toDouble();
      }
      print(totalportfolioValue);
    });

  }

  getpriceColor(double profit){
    if(profit<0){
      return Colors.red;
    }else{
      return Colors.green;
    }
  }
}
