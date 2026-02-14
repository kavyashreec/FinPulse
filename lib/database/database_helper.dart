import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sms_id TEXT UNIQUE,
        amount REAL,
        merchant TEXT,
        category TEXT,
        type TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await database;

    return await db.insert(
      'transactions',
      row,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await database;

    return await db.query(
      'transactions',
      orderBy: 'timestamp DESC',
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('transactions');
  }
}
