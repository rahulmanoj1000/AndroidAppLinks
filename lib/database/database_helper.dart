import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//static final is used when the value should be changed when an instance is created
class DatabaseHelper {
  static const _dbName = 'myDatabase.db';
  static const _dbVersion = 1;
  static const _tableName = 'myTable';
  static const _tableLinks = 'myLinks';

  static const columnId = '_id';
  static const columntitle = 'title';
  static const columnbody = 'body';
  static const textPriority = 'textPriority';

  static const linksId = 'links_id';
  static const linksName = 'links_name';
  static const link = 'link';
  static const linkPriority = 'linkPriority';

  //making a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columntitle TEXT NOT NULL,
      $columnbody TEXT,
      $textPriority TEXT
      )

      ''');

    await db.execute('''
  CREATE TABLE $_tableLinks (
    $linksId INTEGER PRIMARY KEY AUTOINCREMENT,
    $linksName TEXT NOT NULL,
    $link TEXT,
    $linkPriority TEXT
  )
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Handle schema changes for version 2, like adding the 'myLinks' table
    }
    // You can add more conditions for different database version upgrades
  }

  //Curd for Texts

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(_tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: '$columnId=?', whereArgs: [id]);
  }

  //Curd for Links

  Future<int> insertLink(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableLinks, row);
  }

  Future<List<Map<String, dynamic>>> queryAllLinks() async {
    Database db = await instance.database;
    return await db.query(_tableLinks);
  }

  Future<int> updateLink(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[linksId];
    return await db
        .update(_tableLinks, row, where: '$linksId=?', whereArgs: [id]);
  }

  Future<int> deleteLink(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableLinks, where: '$linksId=?', whereArgs: [id]);
  }
}
