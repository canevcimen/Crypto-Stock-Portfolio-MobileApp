import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/api/apiModel/item.dart';
import 'package:stock_investment_flutter/main.dart';
import 'package:stock_investment_flutter/model/buy.dart';
import 'package:stock_investment_flutter/model/stock_invest_model.dart';
import 'package:stock_investment_flutter/model/watchlist.dart';
import 'package:stock_investment_flutter/utils/images.dart';

import '../api/apiModel/coin.dart';
import '../api/apiModel/coinGeckoResponse.dart';
import '../api/apiModel/news.dart';
import '../api/apiModel/newsDataResponse.dart';
import '../api/coinGeckoApi.dart';
import '../model/dbHelper.dart';
import '../model/portfolio.dart';
import '../model/priceDetail.dart';
import '../model/sell.dart';
import '../model/user.dart';

PostgreSQLHelper postgreSQLHelper = new PostgreSQLHelper();

initDatabaseConnection() async {
   await postgreSQLHelper.initDatabaseConnection();
}

Future<List<StockInvestModel>> watchList(int? userID) async {
  
  List<Watchlist> watchList = await postgreSQLHelper.getWatchlistObjs(userID);
  List<StockInvestModel> watchListData = [];
  List<Item> items = [];


  for(Watchlist watchlistitem in watchList){
    
    String coin_id = watchlistitem.coin_id.toString();
    var response = await CoinGeckoApi.getCoinWithId(coin_id);
    final item = json.decode(response.body);
    items.add(Item.forWatchList(item));
  }

  for(Item item in items){
    
    var icon;
    var priceColor;
    if(item.price_change_percentage_24h!<0 || item.price_change_percentage_24h==null){
       icon = Icon(Icons.keyboard_arrow_down, size: 10, color: white);
       priceColor= redColor;
    }else{
       icon = Icon(Icons.keyboard_arrow_up, size: 10, color: white);
       priceColor= greenColor;
    }
    watchListData.add(StockInvestModel(
      id: item.id,
      icon: icon,
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: item.small, 
      title: item.symbol,
      subTitle: item.name,
      stockPrice: "\$"+item.current_price.toString(),
      stockScale: item.price_change_percentage_24h.toString()+"%",
      priceColor: priceColor));

  }
  
  
  return watchListData;
}

//TREND OKAY
Future<List<StockInvestModel>> trendingStockList() async {

    List<StockInvestModel> trendingStockData = [];
    var response = await CoinGeckoApi.getTrendCoins();
    final item = json.decode(response.body);
    var coingeckorespone = CoinGeckoResponse.fromJson(item);

    List<Coin> coins = coingeckorespone.coins;
    for(Coin coin in coins){
      trendingStockData.add(
      StockInvestModel(icon: Icon(Icons.keyboard_arrow_up, size: 10, color: white), imageBackground: pink, image: coin.item!.small, id: coin.item!.id, title: coin.item!.symbol, subTitle: coin.item!.name, priceColor: greenColor, market_cap_rank: coin.item!.market_cap_rank));
       
    }
    
    return trendingStockData;
}
//haber okay
Future<List<StockInvestModel>> stockNewsList() async {
  List<StockInvestModel> stockNewsData = [];

  var response = await CoinGeckoApi.getNews();
  final item = json.decode(response.body);
  var newsResponse = NewsDataResponse.fromJson(item);
  List<News> newsList = newsResponse.news;
  
   for(News news in newsList){
    print(news.thumb_2x);
    stockNewsData.add(StockInvestModel(image: news.thumb_2x, title:news.tittle , subTitle: news.news_site, stockScale: "yesterday", url: news.url,priceColor: greenColor, updated_at: news.updated_at));
  }

  return stockNewsData;
}

//top 10 marketcap 
Future<List<StockInvestModel>> bigMCList() async {
  List<StockInvestModel> bigMCData = [];
  var response = await CoinGeckoApi.getBigMCCoins();
  final itemJsons = json.decode(response.body);
  print(itemJsons);
  List<Item> items = [];
  for(var itemJson in itemJsons){
    items.add(Item.forBigMC(itemJson));
  }
  for(Item item in items){
    
    var icon;
    var priceColor;
    if(item.price_change_percentage_24h!<0 || item.price_change_percentage_24h==null){
       icon = Icon(Icons.keyboard_arrow_down, size: 10, color: white);
       priceColor= redColor;
    }else{
       icon = Icon(Icons.keyboard_arrow_up, size: 10, color: white);
       priceColor= greenColor;
    }
    bigMCData.add(StockInvestModel(
      id: item.id,
      icon: icon,
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: item.image, //değiştir
      title: item.symbol!.toUpperCase(),
      subTitle: item.name!.toUpperCase(),
      stockPrice: "\$"+item.current_price.toString(),
      stockScale: item.price_change_percentage_24h.toString()+"%",
      priceColor: priceColor
      ));

  }

  /*
  bigMCData.add(StockInvestModel(
      subTitle: "AMD", icon: Icon(Icons.add, size: 10, color: white), imageBackground: appStore.isDarkModeOn ? cardDarkColor : black, image: amd_stock, title: "AMD", stockPrice: "\$303.89", stockScale: "60.0% (1.78%)", priceColor: greenColor));
  bigMCData.add(StockInvestModel(subTitle: "ABNB", icon: Icon(Icons.remove, size: 10, color: white), imageBackground: pink, image: abnb_stock, title: "ABNB", stockPrice: "\$101.89", stockScale: "3.10% (2.78%)", priceColor: redColor));
  bigMCData.add(StockInvestModel(
      subTitle: "AMD", icon: Icon(Icons.add, size: 10, color: white), imageBackground: appStore.isDarkModeOn ? cardDarkColor : black, image: amd_stock, title: "AMD", stockPrice: "\$200.89", stockScale: "50.0% (4.78%)", priceColor: greenColor));
  bigMCData.add(StockInvestModel(subTitle: "ABNB", icon: Icon(Icons.remove, size: 10, color: white), imageBackground: pink, image: abnb_stock, title: "ABNB", stockPrice: "\$300.89", stockScale: "1.20%(1.50%)", priceColor: redColor));
  bigMCData.add(StockInvestModel(
      subTitle: "AMD", icon: Icon(Icons.add, size: 10, color: white), imageBackground: appStore.isDarkModeOn ? cardDarkColor : black, image: amd_stock, title: "AMD", stockPrice: "\$303.89", stockScale: "60.0% (1.78%)", priceColor: greenColor));
  bigMCData.add(StockInvestModel(subTitle: "ABNB", icon: Icon(Icons.remove, size: 10, color: white), imageBackground: pink, image: abnb_stock, title: "ABNB", stockPrice: "\$101.89", stockScale: "3.10% (2.78%)", priceColor: redColor));
  bigMCData.add(StockInvestModel(
      subTitle: "AMD", icon: Icon(Icons.add, size: 10, color: white), imageBackground: appStore.isDarkModeOn ? cardDarkColor : black, image: amd_stock, title: "AMD", stockPrice: "\$200.89", stockScale: "50.0% (4.78%)", priceColor: greenColor));
  bigMCData.add(StockInvestModel(subTitle: "ABNB", icon: Icon(Icons.remove, size: 10, color: white), imageBackground: pink, image: abnb_stock, title: "ABNB", stockPrice: "\$300.89", stockScale: "1.20%(1.50%)", priceColor: redColor));
  */
  return bigMCData;
}

//volumedata getVolumeDescCoins
Future<List<StockInvestModel>> volumeList() async {
  List<StockInvestModel> volumeList = [];
  List<Item> items = [];
  var response = await CoinGeckoApi.getVolumeDescCoins();
  final itemJsons = json.decode(response.body);
  print(itemJsons);
  for(var itemJson in itemJsons){
    items.add(Item.forVolumeList(itemJson));
  }

  for(Item item in items){
    
    var icon;
    var priceColor;
    if(item.price_change_percentage_24h!<0 || item.price_change_percentage_24h==null){
       icon = Icon(Icons.keyboard_arrow_down, size: 10, color: white);
       priceColor= redColor;
    }else{
       icon = Icon(Icons.keyboard_arrow_up, size: 10, color: white);
       priceColor= greenColor;
    }
    volumeList.add(StockInvestModel(
      id: item.id,
      icon: icon,
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: item.image, //değiştir
      title: item.symbol!.toUpperCase(),
      subTitle: item.name!.toUpperCase(),
      stockPrice: "\$"+item.current_price.toString(),
      stockScale: item.price_change_percentage_24h.toString()+"%",
      priceColor: priceColor));

  }
  
  
  return volumeList;
}


//search bar 
Future<List<StockInvestModel>> searchedCoinList(String searchQuery) async {
  List<StockInvestModel> searchCoinList = [];
  List<Item> items = [];
  var response = await CoinGeckoApi.searchCoin(searchQuery);
  final decodedFormat = json.decode(response.body);
  print(decodedFormat);
  var listOfItems  = decodedFormat["coins"];

  for(var itemJson in listOfItems){
    items.add(Item.forSearchList(itemJson));
  }
  
  for(Item item in items){
    print(item.id);
    searchCoinList.add(StockInvestModel(image: item.thumb, title: item.symbol, subTitle:item.name, market_cap_rank: item.market_cap_rank ));
  }
  return searchCoinList;

}

//zaman-fiyat pairs
Future<PriceDetail> marketChartList(String coin_id, String days, [String? interval]) async {
  List<FlSpot> priceItems=[];
  var response = await CoinGeckoApi.getMarketChart(coin_id,days,interval);
  final item = json.decode(response.body);
  var prices = item["prices"];
  for(var price in prices){
    priceItems.add(FlSpot(double.parse(price[0].toString()), double.parse(price[1].toString())));
  }
  PriceDetail priceDetail = new PriceDetail(priceItems);
  return priceDetail;
}


//stok detail infos
Future<Item> detailedCoin(String coin_id) async {
  var response = await CoinGeckoApi.getCoinWithId(coin_id);
  final result = json.decode(response.body);
  Item item = Item.forDetailCoin(result);
  
  return item;

}

Future<void> insertBuy(Buy newBuy) async {
  await postgreSQLHelper.insertBuy(newBuy);
}
Future<void> insertSell(Sell newSell) async {
  await postgreSQLHelper.insertSell(newSell);
}


List<Buy> getAverageBuyList(List<Buy> buys){
  List<Buy> averageBuys = [];
  
  for(Buy buy in buys){

    // if avere buys not cointains
    bool isAvarageBuysIncludes = false;
    for(Buy avarageBuy in averageBuys){
      if(avarageBuy.coinId == buy.coinId){
        isAvarageBuysIncludes = true;
      }
    }

    print(isAvarageBuysIncludes);
    if(!isAvarageBuysIncludes){


      List<Buy> temps=[];
      for(Buy e in buys){
        if(e.coinId ==buy.coinId){
          temps.add(e);
        }
      }

      String coinId = buy.coinId.toString();
      double piece =0.0;
      double totalMoney=0.0;

      for(Buy temp in temps){
      
        piece += temp.piece!.toDouble();
        totalMoney += temp.piece!.toDouble() * temp.buying_price!.toDouble();
      }
      double avarageBuyPrice = totalMoney/piece;
      averageBuys.add(Buy.withoutId(buy.userId, buy.coinId, piece, avarageBuyPrice,buy.buying_time));
    }

  }


  
  return averageBuys;
}


List<Sell> getAverageSellList(List<Sell> sells){
  List<Sell> averageSells = [];
  
  for(Sell sell in sells){

    // if avere buys not cointains
    bool isAvarageBuysIncludes = false;
    for(Sell avarageSell in averageSells){
      if(avarageSell.coinId == sell.coinId){
        isAvarageBuysIncludes = true;
      }
    }

    print(isAvarageBuysIncludes);
    if(!isAvarageBuysIncludes){


      List<Sell> temps=[];
      for(Sell e in sells){
        if(e.coinId ==sell.coinId){
          temps.add(e);
        }
      }

      String coinId = sell.coinId.toString();
      double piece =0.0;
      double totalMoney=0.0;

      for(Sell temp in temps){
      
        piece += temp.piece!.toDouble();
        totalMoney += temp.piece!.toDouble() * temp.selling_price!.toDouble();
      }
      double avarageSellPrice = totalMoney/piece;
      averageSells.add(Sell.withoutId(sell.userId, sell.coinId, piece, avarageSellPrice,sell.selling_time));
    }

  }


  
  return averageSells;
}



//portfolio components
Future<List<Portfolio>> assertsList(User? user) async {

  List<Buy> buys = await postgreSQLHelper.getAllBuys(user!.id);
  List<Sell> sells = await postgreSQLHelper.getAllSells(user!.id);
  

  //USERIN BUY LİSTİNİ ÇEK SELL LİSTİNİ ÇEK
  /*
  List<Buy> buys = [Buy(1, 1, "sui", 100.0, 1.0, "21312312321"),
                    Buy(2, 1, "sui", 200.0, 2.0, "21312312321"),
                    Buy(3, 1, "sui", 100.0, 2.0, "21312312321"),
                    Buy(4, 1, "bitcoin", 1, 27500.0, "21312312321")];
  
  
  List<Sell> sells = [Sell(1, 1, "sui", 100.0, 1.5, "21312312321"),
                    Sell(2, 1, "sui", 200.0, 1.25, "21312312321")];
  */
  // buy(//coin_id , alınantoplamadet, alımortalaması)
  //yatırılanToplamaPara alınanadet*ortlama
  List<Buy> averageBuys= getAverageBuyList(buys);
  
  //sell(coin_id, satılanToplamAdet, satımortalaması)
  List<Sell> averageSells = getAverageSellList(sells);
  

  List<Portfolio> portfolioItems = [];

  for(Buy avarageBuy in averageBuys){
    String coinId = avarageBuy.coinId.toString();
    var response = await CoinGeckoApi.getCoinWithId(coinId);
    final item = json.decode(response.body);
    String id = item["id"];
    String symbol = item["symbol"];
    String name = item["name"];
    String image = item["image"]["small"];
    double currentPrice = double.parse(item["market_data"]["current_price"]["usd"].toString());
    
    double? portfolioValue;
    double? profit;
    double? piece;

    bool anySell = false;
    for(Sell avarageSell in averageSells){
      if(avarageSell.coinId == avarageBuy.coinId){
        anySell = true;
        break;
      }
    }

    if(anySell){ // herhangi bi satım varsa
    Sell? sold;
    for(Sell avarageSell in averageSells){
      if(avarageSell.coinId == avarageBuy.coinId){
       sold = avarageSell;
       portfolioValue = (avarageBuy.piece!.toDouble() - sold.piece!.toDouble())*currentPrice;
       profit = portfolioValue - (avarageBuy.piece!.toDouble()* avarageBuy.buying_price!.toDouble()) +(sold.piece!*sold.selling_price!.toDouble());
       piece = avarageBuy.piece!.toDouble() - sold.piece!.toDouble();
       break;
      }
    }
    }else{
      portfolioValue = avarageBuy.piece!.toDouble() * currentPrice;
      profit = portfolioValue - (avarageBuy.piece!.toDouble()* avarageBuy.buying_price!.toDouble());
      piece = avarageBuy.piece!.toDouble();
    }

    portfolioItems.add(Portfolio(id, symbol, name, image, portfolioValue, profit,piece));
  }

  
  return portfolioItems;
}













//KULLANILMIYOR
List<StockInvestModel> sectorStockList() {
  List<StockInvestModel> sectorStockData = [];

  sectorStockData.add(StockInvestModel(image: ic_technology, title: "Technology", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_transport, title: "Transport", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_energy, title: "Energy", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_non_cylical, title: "Non-Cylical", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_industrial, title: "Industrial", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_finance, title: "Finance", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_property, title: "Property", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_Infrastruc, title: "Infrastruc", stockScale: "+0.29%", priceColor: greenColor));
  sectorStockData.add(StockInvestModel(image: ic_health, title: "Helth", stockScale: "+0.29%", priceColor: greenColor));

  return sectorStockData;
}






List<StockInvestModel> getProfileDataModel() {
  List<StockInvestModel> profileList = [];
  profileList.add(StockInvestModel(settingIcon: Icons.person, title: "Edit Profile"));
  profileList.add(StockInvestModel(settingIcon: Icons.notifications, title: "Notification"));
  profileList.add(StockInvestModel(settingIcon: Icons.lock, title: "Privacy & Policy"));
  profileList.add(StockInvestModel(settingIcon: Icons.question_mark, title: "Help Support"));

  return profileList;
}

List<StockInvestModel> fakestockNewsList()  {
  List<StockInvestModel> stockNewsData = [];
  stockNewsData.add(StockInvestModel(image: amd_stock, title: "Stock market LIVE updates: Sensex rises nearly 400 pts, Nifty above 18,550;", subTitle: "Buisness", stockScale: "yesterday", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: amazon_logo, title: "What's the global view on US Fed? Watch this", subTitle: "Buisness", stockScale: "49 min ago", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: netflix, title: "KM Birla is looking for buyers for 19-yr-old insurance brokerage co", subTitle: "Buisness", stockScale: "1 min ago", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: abnb_stock, title: "India could attract close to \$10 bn in renewable energy investment", subTitle: "Buisness", stockScale: "2 hours ago", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: amd_stock, title: "Stock market LIVE updates: Sensex rises nearly 400 pts, Nifty above 18,550;", subTitle: "Buisness", stockScale: "yesterday", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: amazon_logo, title: "What's the global view on US Fed? Watch this", subTitle: "Buisness", stockScale: "49 min ago", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: netflix, title: "KM Birla is looking for buyers for 19-yr-old insurance brokerage co", subTitle: "Buisness", stockScale: "1 min ago", priceColor: greenColor));
  stockNewsData.add(StockInvestModel(image: abnb_stock, title: "India could attract close to \$10 bn in renewable energy investment", subTitle: "Buisness", stockScale: "2 hours ago", priceColor: greenColor));

  return stockNewsData;
}
List<StockInvestModel> fakewatchList() {
  List<StockInvestModel> watchListData = [];
  watchListData.add(StockInvestModel(
      icon: Icon(Icons.keyboard_arrow_up, size: 10, color: white),
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182",
      title: "NFLX",
      subTitle: "Netflix, Inc.",
      stockPrice: "\$303.89",
      stockScale: "1.78%",
      priceColor: greenColor));
  watchListData.add(
      StockInvestModel(icon: Icon(Icons.keyboard_arrow_down, size: 10, color: white), imageBackground: Colors.yellow, image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182", title: "AMZN", subTitle: "Amazon, Inc.", stockPrice: "\$101.89", stockScale: "2.78%", priceColor: redColor));
  watchListData.add(StockInvestModel(
      icon: Icon(Icons.keyboard_arrow_up, size: 10, color: white),
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182",
      title: "NFLX",
      subTitle: "Netflix, Inc.",
      stockPrice: "\$200.89",
      stockScale: "4.78%",
      priceColor: greenColor));
  watchListData.add(
      StockInvestModel(icon: Icon(Icons.keyboard_arrow_down, size: 10, color: white), imageBackground: Colors.yellow, image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182", title: "AMZN", subTitle: "Amazon, Inc.", stockPrice: "\$300.89", stockScale: "1.50%", priceColor: redColor));
  watchListData.add(StockInvestModel(
      icon: Icon(Icons.keyboard_arrow_up, size: 10, color: white),
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182",
      title: "NFLX",
      subTitle: "Netflix, Inc.",
      stockPrice: "\$303.89",
      stockScale: "1.78%",
      priceColor: greenColor));
  watchListData.add(
      StockInvestModel(icon: Icon(Icons.keyboard_arrow_down, size: 10, color: white), imageBackground: Colors.yellow, image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182", title: "AMZN", subTitle: "Amazon, Inc.", stockPrice: "\$101.89", stockScale: "2.78%", priceColor: redColor));
  watchListData.add(StockInvestModel(
      icon: Icon(Icons.keyboard_arrow_up, size: 10, color: white),
      imageBackground: appStore.isDarkModeOn ? cardDarkColor : black,
      image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182",
      title: "NFLX",
      subTitle: "Netflix, Inc.",
      stockPrice: "\$200.89",
      stockScale: "4.78%",
      priceColor: greenColor));
  watchListData.add(
      StockInvestModel(icon: Icon(Icons.keyboard_arrow_down, size: 10, color: white), imageBackground: Colors.yellow, image: "https://assets.coingecko.com/coins/images/26375/small/sui_asset.jpeg?1683114182", title: "AMZN", subTitle: "Amazon, Inc.", stockPrice: "\$300.89", stockScale: "1.50%", priceColor: redColor));

  return watchListData;
}


