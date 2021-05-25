import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final _dbName = 'AddIT.db';
  static final _dbVersion = 1;

  static final _tableName = 'DayTable';
  static final dayIdCol = 'id';
  static final dayFullDateCol = 'DayDate';
  static final dayMonthCol = 'DayMonth';
  static final dayValueCol = 'DayValue';

  static final _tableName2 = 'MonthTable';
  static final monthIdCol = 'id2';
  static final monthValueCol = 'MonthValue';
  static final monthCol = 'Month';
  static final monthDateCol = 'MonthDate';

  static final _tableName3 = 'ItemTable';
  static final itemIdCol = 'ItemId';
  static final itemDateCol = 'ItemDate';
  static final itemCol = 'Item';
  static final itemPriceCol = 'ItemPrice';
  static final itemMonthCol = 'ItemMonth';

  static final _tableName4 = 'LimitTable';
  static final limitIdCol = 'LimitId';
  static final limitDayCol = 'LimitDay';
  static final limitMonthCol = 'LimitMonth';

  DataBaseHelper._privateConstructor();

  static final instance = DataBaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    print('creating');
    try {
      _database = await _initializeDataBase();
      print('created');
    } catch (e) {
      print(e);
    }
    return _database;
  }

  _initializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $dayIdCol INTEGER PRIMARY KEY,
        $dayValueCol INTEGER,
        $dayFullDateCol TEXT NOT NULL,
        $dayMonthCol TEXT NOT NULL)
      ''');

    await db.execute('''
      CREATE TABLE $_tableName2 (
      $monthIdCol INTEGER PRIMARY KEY AUTOINCREMENT,
      $monthCol TEXT NOT NULL,
      $monthValueCol INTEGER,
      $monthDateCol TEXT NOT NULL)   
    ''');

    await db.execute('''
      CREATE TABLE $_tableName3(
      $itemIdCol INTEGER PRIMARY KEY,
      $itemDateCol TEXT NOT NULL,
      $itemCol TEXT NOT NULL,
      $itemPriceCol INTEGER,
      $itemMonthCol TEXT NOT NULL)
    ''');
    await db.execute('''
      CREATE TABLE $_tableName4(
      $limitIdCol INTEGER,
      $limitDayCol INTEGER,
      $limitMonthCol INTEGER)
    ''');
  }

  //Day Operations

  Future<int> dayInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<int> dayUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String date = row[dayFullDateCol];
    return await db
        .update(_tableName, row, where: '$dayFullDateCol=?', whereArgs: [date]);
  }

  dayDelete(String date) async {
    Database db = await instance.database;
    await db.delete(_tableName, where: '$dayFullDateCol=?', whereArgs: [date]);
  }

  dayDeleteWithMonth(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String month = row[DataBaseHelper.dayMonthCol];
    await db.delete(_tableName, where: '$dayMonthCol=?', whereArgs: [month]);
  }

  dayDeleteAll() async {
    Database db = await instance.database;
    db.delete(_tableName);
  }

  dayQueryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  dayQueryForMonth(String month) async {
    Database db = await instance.database;
    return await db
        .query(_tableName, where: '$dayMonthCol=?', whereArgs: [month]);
  }

  //Month Operations

  Future<int> monthInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName2, row);
  }

  Future<int> monthUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String month = row[DataBaseHelper.monthCol];
    return await db
        .update(_tableName2, row, where: '$monthCol=?', whereArgs: [month]);
  }

  monthDelete(String month) async {
    Database db = await instance.database;
    db.delete(_tableName2, where: '$monthCol=?', whereArgs: [month]);
  }

  monthDeleteAll() async {
    Database db = await instance.database;
    db.delete(_tableName2);
  }

  monthQueryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName2);
  }

  //Item Operations

  Future<int> itemInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.insert(_tableName3, row);
  }

  itemDelete(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[DataBaseHelper.itemIdCol];
    await db.delete(_tableName3, where: '$itemIdCol=?', whereArgs: [id]);
  }

  itemDeleteWithDate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String date = row[DataBaseHelper.dayFullDateCol];
    await db.delete(_tableName3, where: '$itemDateCol=?', whereArgs: [date]);
  }

  itemDeleteWithMonth(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String month = row[DataBaseHelper.itemMonthCol];
    await db.delete(_tableName3, where: '$itemMonthCol=?', whereArgs: [month]);
  }

  itemDeleteAll() async {
    Database db = await instance.database;
    await db.delete(_tableName3);
  }

  Future<int> itemUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[DataBaseHelper.itemIdCol];
    return db.update(_tableName3, row, where: '$itemIdCol=?', whereArgs: [id]);
  }

  itemQuery(String date) async {
    Database db = await instance.database;
    return await db
        .query(_tableName3, where: '$itemDateCol=?', whereArgs: [date]);
  }

  limitInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(_tableName4, row);
  }

  limitUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.update(_tableName4, row);
  }

  limitRead() async {
    Database db = await instance.database;
    return await db.query(_tableName4);
  }
}
