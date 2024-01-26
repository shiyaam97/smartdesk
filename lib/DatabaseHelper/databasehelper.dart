import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final _databaseName = "smartdesk.db";
  static final _databaseVersion = 4;

  static final table = 'student';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnClass = 'class';

  static final table1 = 'periods';
  static final table1Type = 'tabletype';
  static final table1Id = 'id';
  static final table1Period = 'period';
  static final table1Time = 'time';


  // Private constructor to prevent instantiation
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(version: _databaseVersion, onCreate: _onCreate));
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnClass TEXT NOT NULL
      )
    ''');

    await db.execute('''
          CREATE TABLE $table1 (
        $columnId INTEGER PRIMARY KEY,
        $table1Type TEXT NOT NULL,
        $table1Period TEXT NOT NULL,
        $table1Time TEXT NOT NULL
      )
    ''');
  }


  Future<bool> updateColumnName(int id, String newName) async {
    Database db = await instance.database;
    int rowsUpdated = await db.update(
      table,
      {'$columnName': newName},
      where: '$columnId = ?',
      whereArgs: [id],
    );
    print('Rows updated: $rowsUpdated');
    return true;


  }


  Future<bool> updatePeriodtime(int id, String time) async {
    Database db = await instance.database;
    int rowsUpdated = await db.update(
      table1,
      {'$table1Time': time},
      where: '$table1Id = ?',
      whereArgs: [id],
    );
    print('Rows updated: $rowsUpdated');
    return true;


  }

  Future<bool> deletePeriodTime(int id) async {
    Database db = await instance.database;
    int rowsdeleted = await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    print('Rows updated: $rowsdeleted');
    return true;


  }

  Future<bool> delete(int id) async {
    Database db = await instance.database;
    int rowsdeleted = await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    print('Rows updated: $rowsdeleted');
    return true;


  }


  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertPeriod(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table1, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
  Future<List<Map<String, dynamic>>> queryAllRowsPeriod() async {
    Database db = await instance.database;
    return await db.query(table1);
  }

}

