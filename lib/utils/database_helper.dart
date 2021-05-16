import 'package:sqflite/sqflite.dart';
import 'package:submission2/model/restaurant_decode.dart';

class DatabaseHelper {
  static Database _database;
  static DatabaseHelper _databaseHelper;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  static String _tableName = 'restaurants';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant_db3.db',
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
        )''',
        );
      },
      version: 2,
    );

    return db;
  }

  Future<void> insertRestaurant(Restaurant resto) async {
    final Database db = await database;
    await db.insert(_tableName, resto.toJson());
  }

  Future<List<Restaurant>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<Restaurant> getDataById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.length != 0) {
      return results.map((res) => Restaurant.fromJson(res)).first;
    } else {
      return null;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
