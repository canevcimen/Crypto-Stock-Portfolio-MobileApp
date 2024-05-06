import 'package:fl_chart/fl_chart.dart';

class PriceDetail{
  List<FlSpot> priceItems;
  double? maxY; //price
  double? minY;
  int? minX;   //timestap
  int? maxX;

  PriceDetail(this.priceItems){
    setMaxY();
    setMinY();
    minX = priceItems.first.x.toInt();
    maxX = priceItems.last.x.toInt();
  }

  setMaxY(){
    maxY = priceItems.reduce((curr, next) => curr.y>next.y ? curr:next).y;
  }

  setMinY(){
    minY = priceItems.reduce((curr, next) => curr.y<next.y ? curr:next).y;
  }


}