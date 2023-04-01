import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBHelper {
  static Database? _database;

  static Future<Database?> getDatabase() async {
    if (_database != null) {
      return _database;
    }

    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'OPC.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE b30ViengThamKH(id INTEGER PRIMARY KEY, time DATETIME, internalID TEXT, businessPartnerName TEXT, objectID TEXT)",
          );
        },
        version: 1,
      );

      return _database;
    } catch (e) {
      print('Error while opening database: ${e.toString()}');
      return null;
    }
  }

  static Future<int> insert(String internalID, String businessPartnerName, String objectID) async {
    final db = await getDatabase();
    return db!.insert('b30ViengThamKH', {
     
    });
  }
}


// Sử dụng hàm insert để chèn dữ liệu