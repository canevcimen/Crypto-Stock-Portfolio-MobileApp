import 'coin.dart';

class CoinGeckoResponse {
  List<Coin> coins = List.empty(growable: true);

  CoinGeckoResponse(this.coins);

  CoinGeckoResponse.fromJson(Map json) {
    if (json['coins'] != null) {
      coins = <Coin>[];
      json['coins'].forEach((v) {
        coins.add(Coin.fromJson(v));
      });
    }
  }
}