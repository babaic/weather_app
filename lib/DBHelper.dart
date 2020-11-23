  
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';


class DBHelper {

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'weather.db'),
        onCreate: (db, version) {
          return db.execute('CREATE TABLE locations(city TEXT PRIMARY KEY, isFavorite INTEGER)');
        }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> update(String table, Map<String, Object> data, String whereKey, String isEqualTo) async {
    final db = await DBHelper.database();
    db.update(table, data, where: "$whereKey = ?", whereArgs: [isEqualTo]);
  }

  static Future<void> delete(String table, String whereKey, String isEqualTo) async {
    final db = await DBHelper.database();
    db.delete(table, where: "$whereKey = ?", whereArgs: [isEqualTo]);
  }






}