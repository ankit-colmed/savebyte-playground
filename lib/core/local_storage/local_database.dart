import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();

  factory LocalDatabase() {
    return _instance;
  }

  LocalDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> init() async {
    await database;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT UNIQUE,
        name TEXT,
        email TEXT,
        profilePicture TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT UNIQUE,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT,
        tableNa TEXT,
        data TEXT,
        status TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere(
      String table,
      String where,
      List<dynamic> whereArgs,
      ) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(
      String table,
      Map<String, dynamic> values,
      String where,
      List<dynamic> whereArgs,
      ) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}