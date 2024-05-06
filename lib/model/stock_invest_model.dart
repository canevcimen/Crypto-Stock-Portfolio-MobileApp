import 'package:flutter/material.dart';

class StockInvestModel {
  String? id;
  String? image;
  String? title; //symbol btc
  String? subTitle; // name bitcoin
  String? stockPrice;
  String? profit;
  String? stockScale;
  Color? priceColor;
  Color? imageBackground;
  Icon? icon;
  IconData? settingIcon;
  int? market_cap_rank;
  int? updated_at;
  String? url;

  StockInvestModel({this.id, this.settingIcon, this.image, this.profit, this.title, this.subTitle, this.stockPrice, this.stockScale, this.priceColor, this.imageBackground, this.icon,this.market_cap_rank, this.updated_at,this.url});
}
