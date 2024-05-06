import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/component/sector_stock_componet.dart';
import 'package:stock_investment_flutter/component/stock%20_futures_component.dart';
import 'package:stock_investment_flutter/component/watch_list_component.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/screens/view_all_stock_gainer_screen.dart';
import 'package:stock_investment_flutter/utils/colors.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/constant.dart';
import 'package:stock_investment_flutter/utils/data_generator.dart';

import '../model/user.dart';

class MarketFragment extends StatefulWidget {
  User user=new User.withoutAnyInfo();

  MarketFragment(User user){
    this.user = user;
  }
  @override
  _MarketFragmentState createState() => _MarketFragmentState(user);
}

class _MarketFragmentState extends State<MarketFragment> {
  List<StockInvestModel> bigMCData = [];
  List<StockInvestModel> sectorStockData = sectorStockList();
  List<StockInvestModel> volumeData =[];
  List<StockInvestModel> searchData = [];
  bool? isActive;

  OverlayEntry? sideSheetOverlayEntry;
  final sideSheetOverlayLayerLink = LayerLink();

  TextEditingController searchCont = TextEditingController();
  User? user;

  _MarketFragmentState(User user){
    this.user=user;
  }

  @override
  void initState() {
    super.initState();
    isActive = true;
    init();
  }

  Future<void> init() async {
    setStatusBarColor(appStore.isDarkModeOn ? black : white);
    setbigMCData();
    setvolumeData();
    setState(() {
      isActive = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void veiwAllSectorStock() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: radiusOnly(topLeft: 25, topRight: 25),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 10,
                width: 40,
                margin: EdgeInsets.only(top: 16),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  backgroundColor: appStore.isDarkModeOn ? white : gray.withOpacity(0.2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Stock Sectors", style: boldTextStyle(size: 18)),
                  IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  )
                ],
              ).paddingOnly(left: 16, top: 16, right: 8),
              Divider(color: appStore.isDarkModeOn ? white : gray.withOpacity(0.2)),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                  sectorStockData.length,
                  (index) {
                    return Container(
                      decoration: commonDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                      margin: EdgeInsets.all(8),
                      width: context.width() * 0.32 - 16,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: appStore.isDarkModeOn ? cardDarkColor : primaryColor,
                            ),
                            child: CommonCachedNetworkImage(sectorStockData[index].image.validate(), color: white, fit: BoxFit.cover, height: 22, width: 22),
                          ),
                          16.height,
                          Marquee(directionMarguee: DirectionMarguee.oneDirection, child: Text(sectorStockData[index].title.validate(), style: boldTextStyle())),
                          4.height,
                          Text(sectorStockData[index].stockScale.validate(), style: secondaryTextStyle()),
                        ],
                      ),
                    );
                  },
                ),
              ).paddingSymmetric(vertical: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppBarWidget(
          context,
          title: "Markets",
          changeIcon: true,
          showLeadingIcon: false,
          iconWidget1: IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.filter_list, color: context.iconColor, size: 22),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              AppTextField(
                onChanged: (searchKey){
                  String input = searchKey;
                  if(!input.isEmpty){
                    setsearchData(input);
                    print(searchData);
                    
                  }else{
                    print("yazılcak bişi yok");
                  }
                },
                textFieldType: TextFieldType.EMAIL,
                controller: searchCont,
                decoration: inputDecoration(
                  context,
                  labelText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: appStore.isDarkModeOn ? white : gray.withOpacity(0.8),
                  ),
                ),
              ).paddingSymmetric(horizontal: 16),
              28.height,
              Text('TOP 10 MARKETCAP', style: boldTextStyle(size: headingTextSize)).paddingOnly(left: 16),
              16.height,
              HorizontalList(
                itemCount: bigMCData.length,
                padding: EdgeInsets.all(16),
                spacing: 16,
                runSpacing: 8,
                itemBuilder: (_, index) => StockFuturesComponent(bigMCData[index],this.user),
              ),/*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sector Stock', style: boldTextStyle(size: headingTextSize)).paddingOnly(left: 16, bottom: 16, top: 16),
                  TextButton(
                    onPressed: () {
                      veiwAllSectorStock();
                    },
                    child: Text('View All', style: secondaryTextStyle()),
                  ).visible(sectorStockData.length >= 5).paddingOnly(right: 8)
                ],
              ),
              HorizontalList(
                itemCount: 20,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (_, index) => SectorStockComponent(sectorStockData[index % sectorStockData.length]),
              ),
              8.height,*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('TRADE HACİMİ ARTAN 15 COİN ', style: boldTextStyle(size: headingTextSize)),
                      4.width,
                      Icon(Icons.keyboard_arrow_down_outlined, color: context.iconColor),
                    ],
                  ).paddingOnly(left: 16),
                  TextButton(
                    onPressed: () {
                      
                    },
                    child: Text('View All', style: secondaryTextStyle()),
                  ).visible(sectorStockData.length >= 5).paddingOnly(right: 8)
                ],
              ),
              8.height,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: volumeData.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (_, index) => WatchListComponent(volumeData[index],this.user).paddingOnly(bottom: 16),
              ).paddingSymmetric(horizontal: 8),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> setbigMCData()async {
    List<StockInvestModel> temp = await bigMCList();
    setState(() {
      this.bigMCData = temp;
    });

  }

  Future<void> setvolumeData()async {
    List<StockInvestModel> temp = await volumeList();
    setState(() {
      this.volumeData = temp;
    });

  }

  Future<void> setsearchData(String searchQuery)async {
    List<StockInvestModel> temp = await searchedCoinList(searchQuery);
    setState(() {
      this.searchData = temp;
    });

  }


}
