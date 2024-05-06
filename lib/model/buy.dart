class Buy{
  int? id;
  int? userId;
  String? coinId;
  double? piece;
  double? buying_price;
  String? buying_time;

  Buy(this.id, this.userId, this.coinId, this.piece, this.buying_price,this.buying_time);

  Buy.withoutId( this.userId, this.coinId, this.piece, this.buying_price,this.buying_time);
  Buy.free();

  Buy.fromJson(Map<String,dynamic> json){
    this.id = int.parse(json["id"].toString());
    this.userId = int.parse(json["user_id"].toString());
    this.coinId = json["coin_id"];
    this.piece = double.parse(json["piece"].toString());
    this.buying_price = double.parse(json["buying_price"].toString());
    //this.buying_time = json["buying_time"].toString();

  }
}