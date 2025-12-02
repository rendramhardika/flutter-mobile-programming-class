import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
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
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        category TEXT,
        priority TEXT
      )
    ''');
  }

  // CREATE
  Future<ItemModel> create(ItemModel item) async {
    final db = await database;
    final id = await db.insert('items', item.toMap());
    return item.copyWith(id: id);
  }

  // READ ALL
  Future<List<ItemModel>> readAll() async {
    final db = await database;
    final result = await db.query(
      'items',
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => ItemModel.fromMap(map)).toList();
  }

  // READ ONE
  Future<ItemModel?> readOne(int id) async {
    final db = await database;
    final maps = await db.query(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemModel.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE
  Future<int> update(ItemModel item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL (for testing)
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('items');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
