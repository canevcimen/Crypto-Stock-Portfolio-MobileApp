class Watchlist{
  int? id;
  int? user_id;
  String? coin_id;

  Watchlist(this.id, this.user_id, this.coin_id);
  Watchlist.fromJson(Map<String,dynamic> json){
    this.id = int.parse(json["id"].toString());
    this.user_id = json["user_id"];
    this.coin_id = json["coin_id"];
  }





}