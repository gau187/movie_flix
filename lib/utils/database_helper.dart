import 'dart:io';

import 'package:movie_flix/models/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  final String table = "MovieTable";
  final String imageURL = "imageURL";
  final String name = "name";
  final String director = "director";

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async{
    if(_db !=null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  DatabaseHelper.internal();

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"movie.db");
    var ourDb = await openDatabase(path,version: 1,onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db,int newVersion) async{
    await db.execute(
      "CREATE TABLE $table(id INTEGER PRIMARY KEY,$imageURL VARCHAR(50),$name VARCHAR(20),$director VARCHAR(30))"
    );
  }
  Future<int> saveData(Movie movie) async{
    var dbClient = await db;
    int res = await dbClient.insert("$table", movie.toMap());
    print("added");
    return res;
  }
  Future<int> updateData(Movie movie,int id) async{
    var dbClient = await db;
    int res = await dbClient.update("$table", movie.toMap(),where: "id = ?", whereArgs: [id]);
    print("updated");
    return res;
  }

  Future<int> getCount() async{
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROm $table"));
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table");
    return result.toList();
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table,
        where: "id = ?", whereArgs: [id]);
  }
}