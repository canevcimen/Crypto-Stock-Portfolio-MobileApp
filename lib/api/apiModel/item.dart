class Item {
  String? id;
  int? coin_id;
  String? name;
  String? symbol;
  int? market_cap_rank;
  String? thumb;
  String? small;
  String? large;
  String? slug;
  String? image;
  double? price_btc;
  int? score;
  double? simplePrice;
  double? current_price;
  double? price_change_percentage_24h;
  double? price_change_percentage_7d;
  double? price_change_percentage_14d;
  double? price_change_percentage_30d;
  double? price_change_percentage_60d;
  double? price_change_percentage_200d;
  double? price_change_percentage_1y;
  double? marketCap;
  double? high_24h;
  double? low_24h;
  double? ath;
  double? atl;

  Item(this.id, this.name, this.symbol, this.market_cap_rank, this.thumb,
      this.small, this.large, this.slug, this.price_btc,this.score);

  Item.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.coin_id = json["coin_id"];
    this.name = json["name"];
    this.symbol = json["symbol"];
    this.market_cap_rank = json["market_cap_rank"];
    this.thumb = json["thumb"];
    this.small = json["small"];
    this.large = json["large"];
    this.slug = json["slug"];
    this.price_btc = double.parse(json["score"].toString());
    this.score = int.parse(json["score"].toString());
  }

  Item.forWatchList(Map<String, dynamic> json){
    this.id = json["id"];
    this.symbol = json["symbol"];
    this.name = json["name"];
    this.thumb = json["image"]["thumb"];
    this.small = json["image"]["small"];
    this.large = json["image"]["large"];
    this.current_price = double.parse(json["market_data"]["current_price"]["usd"].toString());
    this.price_change_percentage_24h = double.parse(json["market_data"]["price_change_percentage_24h"].toString());

  }

  Item.forBigMC(Map<String,dynamic> json){
    this.id = json["id"];
    this.symbol = json["symbol"];
    this.name = json["name"];
    this.image = json["image"];
    this.current_price = double.parse(json["current_price"].toString());
    this.price_change_percentage_24h = double.parse(json["price_change_percentage_24h"].toString());
    this.market_cap_rank = json["market_cap_rank"];
    

  }

  Item.forVolumeList(Map<String,dynamic> json){
    this.id = json["id"];
    this.symbol = json["symbol"];
    this.name = json["name"];
    this.image = json["image"];
    this.current_price = double.parse(json["current_price"].toString());
    this.price_change_percentage_24h = double.parse(json["price_change_percentage_24h"].toString());
  }

   Item.forSearchList(Map<String,dynamic> json){
    this.id = json["id"];
    this.symbol = json["symbol"];
    this.name = json["name"];
    //"api_symbol": "bitcoin",
    this.market_cap_rank = json["market_cap_rank"];
    this.thumb = json["thumb"];
    this.large = json["large"];
  }

  Item.forDetailCoin(Map<String,dynamic> json){
    this.id = json["id"];
    this.symbol = json["symbol"];
    this.name = json["name"];
    this.thumb = json["image"]["thumb"];
    this.small = json["image"]["small"];
    this.large = json["image"]["large"];
    this.current_price = double.parse(json["market_data"]["current_price"]["usd"].toString());
    this.price_change_percentage_24h = double.parse(json["market_data"]["price_change_percentage_24h"].toString());
    this.price_change_percentage_7d = double.parse(json["market_data"]["price_change_percentage_7d"].toString());
    this.price_change_percentage_14d = double.parse(json["market_data"]["price_change_percentage_14d"].toString());
    this.price_change_percentage_30d = double.parse(json["market_data"]["price_change_percentage_30d"].toString());
    this.price_change_percentage_60d = double.parse(json["market_data"]["price_change_percentage_60d"].toString());
    this.price_change_percentage_200d = double.parse(json["market_data"]["price_change_percentage_200d"].toString());
    this.price_change_percentage_1y = double.parse(json["market_data"]["price_change_percentage_1y"].toString());
    this.market_cap_rank = json["market_data"]["market_cap_rank"];
    this.marketCap = double.parse(json["market_data"]["market_cap"]["usd"].toString());
    this.high_24h = double.parse(json["market_data"]["high_24h"]["usd"].toString());
    this.low_24h = double.parse(json["market_data"]["low_24h"]["usd"].toString());
    this.ath = double.parse(json["market_data"]["ath"]["usd"].toString());
    this.atl = double.parse(json["market_data"]["atl"]["usd"].toString());
    
  }



}