import 'package:postgres/postgres.dart';

class DbConnection {
  var databaseConnection;

  DbConnection() {
    this.databaseConnection = PostgreSQLConnection(
        '91.225.104.133', 5432, 'stockmarket',
        queryTimeoutInSeconds: 3600,
        timeoutInSeconds: 3600,
        username: 'stockmarket',
        password: 'X151o8rU');
    this.initDatabaseConnection();
  }

  initDatabaseConnection() async {
    databaseConnection.open().then((value) {
      print("Database Connected!");
    });
  }
}


/* Deneme amaçlı yapıldı* */
/* Deneme amaçlı yapıldı* */
//biraderim dedi konu kilit