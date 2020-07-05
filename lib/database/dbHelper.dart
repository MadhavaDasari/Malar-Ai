import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'model.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'photoName';
  static const String TABLE = 'PhotosTable';
  static const String DB_NAME = 'photos.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY NOT NULL, $NAME TEXT,"name" TEXT,"result" TEXT,"prob" TEXT,"date" TEXT)');
  }

  Future<int> save(Photo result) async {
    debugPrint("reached");
    var dbClient = await db;
    var x = await dbClient.insert(TABLE, result.toMap());
    return x;
  }

  Future<int> delete(int id) async {
    Database dbClint = await this.db;

    int x = await dbClint.delete(TABLE, where: '"id"=?', whereArgs: [id]);
    return x;
  }

  Future<List<Photo>> getPhotos() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, NAME, "name", "result", "prob", "date"]);
    List<Photo> results = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        results.add(Photo.fromMap(maps[i]));
      }
    }
    return results;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
