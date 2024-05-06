class Sell{
  int? id;
  int? userId;
  String? coinId;
  double? piece;
  double? selling_price;
  String? selling_time;

  Sell(this.id, this.userId, this.coinId, this.piece, this.selling_price,this.selling_time);

  Sell.withoutId( this.userId, this.coinId, this.piece, this.selling_price,this.selling_time);

  Sell.fromJson(Map<String,dynamic> json){
    this.id = int.parse(json["id"].toString());
    this.userId = int.parse(json["user_id"].toString());
    this.coinId = json["coin_id"];
    this.piece = double.parse(json["piece"].toString());
    this.selling_price = double.parse(json["selling_price"].toString());
    //this.selling_time = json["selling_time"].toString();

  }
}