import 'news.dart';

class NewsDataResponse{
  List<News> news=List.empty(growable: true);

  NewsDataResponse(this.news);

  NewsDataResponse.fromJson(Map json) {
    if (json['data'] != null) {
      news = <News>[];
      json['data'].forEach((v) {
        news.add(News.fromJson(v));
      });
    }
  }

  
}