class News{
  String? tittle;
  String? description;
  String? author;
  String? url;
  String? news_site;
  String? thumb_2x;
  int? updated_at; //timestap

  News.fromJson(Map<String,dynamic> json){
    this.tittle = json["title"];
    this.description = json["description"];
    this.author = json["author"];
    this.url = json["url"];
    this.news_site = json["news_site"];
    this.thumb_2x = json["thumb_2x"];
    this.updated_at = int.parse(json["updated_at"].toString());
  }

}

