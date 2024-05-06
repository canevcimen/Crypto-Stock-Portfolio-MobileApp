import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
class CoinGeckoApi{
  static Future getTrendCoins() async {
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/search/trending"));
  }

  static Future getCoinWithId(String coin_id){
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/"+coin_id+"?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false"));
  }

  static Future getNews(){
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/news"));
  }

  static Future getBigMCCoins(){
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false&locale=en"));
  }

  static Future getVolumeDescCoins(){
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=volume_desc&per_page=15&page=1&sparkline=false&locale=en"));
  }

  static Future searchCoin(String searchQuery){
    //Search for coins, categories and markets listed on CoinGecko ordered by largest Market Cap first
    return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/search?query=$searchQuery"));
  }
  
  static Future getMarketChart(String coin_id, String days, [String? interval]){
    if(interval.isEmptyOrNull){
      return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/$coin_id/market_chart?vs_currency=usd&days=$days&interval=$interval"));
    }else{
      return http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins/$coin_id/market_chart?vs_currency=usd&days=$days"));
    }
  }
  

  
  
}