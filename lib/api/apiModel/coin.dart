import 'item.dart';

class Coin {
  Item? item;

  Coin(this.item);
  Coin.fromJson(Map json) {
    item = Item.fromJson(json["item"]);
  }
}