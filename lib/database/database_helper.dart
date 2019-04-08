import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_cookbook/models/cookbook.dart';

class DatabaseHelper  {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TheCookbook.db");
    var theCookbookDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theCookbookDb;
  }


  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Cookbooks ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "coverBase64Encoded TEXT,"
        "deleted BIT"
        ")");
  }

  // Cookbook CRUD

  Future<int> saveCookbook(Cookbook cookbook) async {
    var theCookbookDb = await db;
    int res = await theCookbookDb.insert("Cookbooks", cookbook.toMap());
    return res;
  }

  Future<List<Cookbook>> getCookbooks() async {
    var dbTheCookbook = await db;
    List<Map> list = await dbTheCookbook.rawQuery('SELECT * FROM Cookbooks');
    List<Cookbook> cookbooks = new List();
    for (int i = 0; i < list.length; i++) {
      var cookbook = new Cookbook(list[i]["name"], list[i]["coverBase64Encoded"]);
      cookbook.setCookbookId(list[i]["id"]);
      cookbooks.add(cookbook);
    }
    print(cookbooks.length);
    return cookbooks;
  }

  Future<int> deleteCookbook(Cookbook cookbook) async {
    var theCookbookDb = await db;
    int res = await theCookbookDb.rawDelete('DELETE FROM Cookbooks WHERE id = ?', [cookbook.id]);
    return res;
  }

  Future<bool> updateCookbook(Cookbook cookbook) async {
    var theCookbookDb = await db;
    int res =   await theCookbookDb.update("Cookbooks", cookbook.toMap(),
        where: "id = ?", whereArgs: <int>[cookbook.id]);
    return res > 0 ? true : false;
  }

  // Recipe CRUD



}