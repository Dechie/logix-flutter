import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/batch.dart';
import '../../models/stock.dart';

class DatabaseHelper {
  static Database? _database;
  final String tableName = '';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'logix_system.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create your table
    await db.execute('''
      CREATE TABLE TheBatch (
        id INTEGER PRIMARY KEY,
        name TEXT,
      );
    ''');

    await db.execute('''
      CREATE TABLE Stock(
        id INTEGER PRIMARY KEY,
        batch_id INTEGER,
        price REAL,
        quantity INTEGER,
        status TEXT,
        arrived_date TEXT,

        FOREIGN KEY(batch_id) REFERENCES TheBatch(id)
      );
    ''');
  }

  Future<void> insertStocks(TheBatch batch, List<Stock> stocks) async {
    final db = _database;

    // Insert the Batch
    int batchId = await db!.insert('TheBatch', batch.toMap());

    // Insert each Stock with the corresponding batchId
    for (Stock stock in stocks) {
      stock.batchId = batchId;
      await db.insert('Stock', stock.toMap());
    }
  }

  Future<void> insertBatch(TheBatch batch) async {
    final db = _database;

    // Insert the Batch
    await db!.insert('TheBatch', batch.toMap());
  }

  Future<List<Stock>> retrieveStocks(TheBatch batch) async {
    final db = _database;

    List<Stock> stocks = [];

    List<Map<String, dynamic>> batchMap = await db!.query('TheBatch',
        where: 'name = ?', whereArgs: [batch.name], limit: 1);

    var batchId = TheBatch.fromMap(batchMap[0]);

    List<Map<String, dynamic>> stockMaps = await db.query(
      'Stock',
      where: 'batch_id = ?',
      whereArgs: [batchId],
    );

    // Convert List<Map<String, dynamic>> to List<Stock>
    return List.generate(stockMaps.length, (index) {
      return Stock(
        batchId: stockMaps[index]['batch_id'],
        price: stockMaps[index]['price'],
        quantity: stockMaps[index]['quantity'],
        arrivedDate: stockMaps[index]['quantity'],
        status: stockMaps[index]['quantity'],
      );
    });
  }

/*
  Future<void> Batch(TheBatch batch) async {
    final db = _database;

    // Insert the Batch
    await db!.insert('TheBatch', batch.toMap());
  }
  */
}
