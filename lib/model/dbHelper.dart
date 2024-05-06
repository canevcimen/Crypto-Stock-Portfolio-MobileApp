import 'package:nb_utils/nb_utils.dart';
import 'package:postgres/postgres.dart';

import 'package:stock_investment_flutter/model/sell.dart';
import 'package:stock_investment_flutter/model/user.dart';
import 'package:stock_investment_flutter/model/watchlist.dart';

import 'buy.dart';

class PostgreSQLHelper {
  /*
  String databaseHost;
  int databasePort;
  String databaseName;
  int queryTimeoutInSeconds;
  int timeoutInSeconds;
  String username;
  String password;*/

  var databaseConnection;

  PostgreSQLHelper() {
    this.databaseConnection = PostgreSQLConnection(
        '*********', 5432, '*********',
        queryTimeoutInSeconds: 3600,
        timeoutInSeconds: 3600,
        username: '**********',
        password: '***********');
    print("default oluşturuldu");
  }

  PostgreSQLHelper.customHelper(
      String databaseHost,
      int databasePort,
      String databaseName,
      int queryTimeoutInSeconds,
      int timeoutInSeconds,
      String username,
      String password) {
    this.databaseConnection = PostgreSQLConnection(
        databaseHost, databasePort, databaseName,
        queryTimeoutInSeconds: queryTimeoutInSeconds,
        timeoutInSeconds: timeoutInSeconds,
        username: username,
        password: password);
    print("custom oluşturuldu");
  }

  initDatabaseConnection() async {
    await databaseConnection.open().then((value) {
      print("Database Connected!");
    });
  }

  closeDatabaseConnection() async {
    databaseConnection.close();
    print("database closed");
  }

  insertUser(User user) async {
     var result = await this.databaseConnection.query('''INSERT INTO public.user(
                  fullname, email, password, photo, phone)
                  VALUES (@fullname, @email, @password,  @photo, @phone);''',substitutionValues:{'fullname': user.fullname, 'email': user.email, 'password':user.password, 'photo':user.photo, 'phone':user.phone });
  

  
  }

  insertBuy(Buy newBuy) async {
    var result = await this.databaseConnection.query('''INSERT INTO public.buy(
                  user_id, coin_id, piece, buying_price)
                  VALUES (@user_id,@coin_id,@piece,@buying_price);''',substitutionValues:{'user_id': newBuy.userId, 'coin_id': newBuy.coinId, 'piece':newBuy.piece, 'buying_price':newBuy.buying_price });
  }


  insertSell(Sell newSell) async {
    var result = await this.databaseConnection.query('''INSERT INTO public.sell(
                  user_id, coin_id, piece, selling_price)
                  VALUES (@user_id,@coin_id,@piece,@selling_price);''',substitutionValues:{'user_id': newSell.userId, 'coin_id': newSell.coinId, 'piece':newSell.piece, 'selling_price':newSell.selling_price });
  }

  getUser(String email, String password) async{
      List<Map<String, Map<String, dynamic>>> result  = await this.databaseConnection.mappedResultsQuery('''SELECT * FROM public.user WHERE email=@email AND password=@password''',
      substitutionValues:{'email': email, 'password':password });
      
    if (result.length == 1) {
      for (var element in result) {
        var _users = element.values.toList();
          User user = User.fromJson(_users[0]);
          return user;
      }
    }  
    return null;

  }
 
  Future<List<Watchlist>> getWatchlistObjs(int? userId)async{
    List<Watchlist> watchlist=[];
    List<Map<String, Map<String, dynamic>>> result  = await this.databaseConnection.mappedResultsQuery('''SELECT * FROM public.watchlist WHERE user_id = @user_id''',
      substitutionValues:{'user_id': userId });
    print(result);
    for (var element in result) {
      var _watchlists = element.values.toList();
        for(var item in _watchlists){
          watchlist.add(Watchlist.fromJson(item));
        }
    }
    return watchlist;
  }


  Future<List<Buy>> getAllBuys(int? userId) async{
    List<Buy> buyList=[];

    List<Map<String, Map<String, dynamic>>> result  = await this.databaseConnection.mappedResultsQuery('''SELECT * FROM public.buy WHERE user_id= @user_id''',
    substitutionValues:{'user_id': userId });

    for (var element in result) {
      var _buys = element.values.toList();
        for(var item in _buys){
          buyList.add(Buy.fromJson(item));
        }
    }

    return buyList;
  }

  Future<List<Sell>> getAllSells(int? userId) async{
    List<Sell> sellList=[];

    List<Map<String, Map<String, dynamic>>> result  = await this.databaseConnection.mappedResultsQuery('''SELECT * FROM public.sell WHERE user_id= @user_id''',
    substitutionValues:{'user_id': userId });

    for (var element in result) {
      var _buys = element.values.toList();
        for(var item in _buys){
          sellList.add(Sell.fromJson(item));
        }
    }

    return sellList;
  }


  isEmailUsed(String email) async{
    var result  = await this.databaseConnection.query('''SELECT * FROM public.user WHERE email=@email ''',
      substitutionValues:{'email': email});
    return result.length;

  }


  

  
  

  
}
