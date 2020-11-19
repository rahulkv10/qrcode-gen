import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Common Class for DataBase
class DatabaseHelper {
  static String registerTable = 'registerTable';
  static String colId = 'id';
  static String name = 'name';
  static String age = 'age';
  static String studentId = 'studentId';
  

  static DatabaseHelper _databaseHelper;
  static Database _database;
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'DataBase.db';
    // Open/create the database at a given path
    var comicDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return comicDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $registerTable($colId iNTEGER PRIMARY KEY AUTOINCREMENT,'
        '$name TEXT, $age TEXT, $studentId TEXT)');
    
  }

  //To insert the data in to the DataBase
  // _inputDbdata: Map<String, dynamic> type data inserting into database
  // _tableName:table name for data inserting
  Future<int> insertDb(
      Map<String, dynamic> _inputDbdata, String _tableName) async {
    Database db = await this.database;
    int resultFromDb = await db.insert(_tableName, _inputDbdata);
    return resultFromDb;
  }

// To delete the data from the Database
// _query:Sql query for Deleting the data from the table
  Future<int> deleteDb(String _query) async {
    Database db = await this.database;
    int resultToDelete = await db.rawDelete(_query);
    return resultToDelete;
  }

// Update the data in Database
// _tableName:table name for data updating
// _updateDbdata:data uploading in database
  Future<int> updateDb(String _tableName, Map<String, dynamic> _updateDbdata,String _where, List<dynamic> _whereArgs ) async {
    Database db = await this.database;
    int resultToUpdate = await db.update(_tableName, _updateDbdata,where:_where,whereArgs:_whereArgs );
    return resultToUpdate;
  }

  // Read tha data in the database
  // _query:Sql query for read the data from the table
  Future<List<Map<String, dynamic>>> readDb(String _query) async {
    Database db = await this.database;
    var resultToUpdate = await db.rawQuery(_query);
    return resultToUpdate;
  }
}
