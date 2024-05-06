class User{
  int? id;
  String? fullname;
  String? email;
  String? password;
  String? photo;
  String? phone="";

  User(this.id, this.fullname, this.email, this.password, this.photo, this.phone){}
  User.withoutId(this.fullname, this.email, this.password, this.photo, this.phone);
  
  
  User.fromJson(Map<String, dynamic> json){
    this.id = int.parse(json["id"].toString());
    this.fullname = json["fullname"];
    this.email = json["email"];
    this.password = json["password"];
    this.photo = json["photo"];
    this.phone = json["phone"];
  }

  User.withoutAnyInfo();

  

}
