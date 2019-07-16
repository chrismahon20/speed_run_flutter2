import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableRuns = 'runs';
final String columnId = '_id';
final String columnTime = 'time';
final String columnDate = 'date';
final String columnNotes = 'notes';
final String columnPath = 'path';

// data model class
class Run {

  int id;
  double time;
  int date;
  String notes;
  String path;

  Run();
  // convenience constructor to create a Word object
  Run.fromMap(Map<String, dynamic> map) {
    var _list = map.values.toList();
    id = _list[0] as int;
    time =_list[1] as double;
    date = _list[2] as int;
    notes = map[columnNotes].toString();
    path = map[columnPath].toString();
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTime: time,
      columnDate: date,
      columnNotes: notes,
      columnPath: path,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "SpeedRuns2.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE runs (
                _id INTEGER PRIMARY KEY,
                time DECIMAL NOT NULL,
                date INTEGER NOT NULL,
                notes TEXT,
                path TEXT
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Run run) async {
    Database db = await database;
    int id = await db.insert(tableRuns, run.toMap());
    return id;
  }

  Future<Run> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableRuns,
        columns: [columnId, columnTime, columnDate, columnNotes, columnPath],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Run.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map>> queryDates() async{
    Database db = await database;
    List<Map> dates = await db.rawQuery("SELECT DISTINCT $columnDate from $tableRuns WHERE $columnDate NOT NULL ORDER BY date");
    if (dates.length > 0) {
      return (dates);
    }
    print("DATABASE EMPTY");
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}