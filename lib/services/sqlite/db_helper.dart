import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/order.dart';
import '../../models/stock.dart';

class DatabaseHelper {
  static Database? _database;
  final String tableName = '';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'logix_system.db');

    print("initDB executed");
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    /*
    await deleteDatabase(path);
    return await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      // Order is keyword in sqlite so wrap our
      // word here with " "
      await db.execute('''
      CREATE TABLE IF NOT EXISTS "Order" (
        id INTEGER PRIMARY KEY,
        staff_email TEXT,
        name TEXT
      );
    ''');
      /*await db.execute(tableEmployee +
          tableAudit +
          tableProject +
          tableJobPosition +
          tableWorkType +
          tableAssignedJobPosition +
          tableTimeTrack +
          tableAllowedWorkType);*/
    });


*/

    //await deleteDatabase(path);
    _database = await openDatabase(path, version: 1, onCreate: _createDatabase);
    if (_database != null) {
      //deleteDatabaseIfExists(_database!);
      print('db not null');
/*
      await _database!.execute('''
      CREATE TABLE IF NOT EXISTS Stock(
        id INTEGER PRIMARY KEY,
        order_id INTEGER,
        price REAL,
        quantity INTEGER,
        status TEXT,
        arrived_date TEXT,

        FOREIGN KEY(order_id) REFERENCES "Order"(id)
      );
    ''');
    
      await _database!.execute('ALTER TABLE "Order" RENAME TO orders;');
      await _database!.execute('ALTER TABLE Stock RENAME TO stocks;');
      
      await _database!
          .execute('ALTER TABLE stocks ADD COLUMN arrived_at TEXT;');
      */

      // Open/create the database at a given path

      return _database!;
    }

    //return _database!;
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Create your table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY,
        staff_email TEXT,
        name TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS stocks(
        id INTEGER PRIMARY KEY,
        order_id INTEGER,
        price REAL,
        quantity INTEGER,
        status TEXT,
        arrived_at TEXT,

        FOREIGN KEY(order_id) REFERENCES orders(id)
      );
    ''');
    print('this executed');
  }

  Future<void> insertOrder(Order order) async {
    final db = _database;

    // Insert the order
    // order table is called TheBatch, cause old table refused to
    // delete for whatever fucking reason
    // so yea we keepin the name
    await db!.insert('orders', order.toMap());
  }

  Future<List<Order>> retrieveOrders() async {
    final db = _database;
    List<Map<String, dynamic>> orderMaps = await db!.query('orders');

    return List.generate(
      orderMaps.length,
      (index) => Order.fromMap(
        orderMaps[index],
      ),
    );
  }

  Future<void> insertStocks(Order order, List<Stock> stocks) async {
    final db = _database;

    // Insert the order
    //int orderId = await db!.insert('orders', order.toMap());
    List<Map<String, dynamic>> orderMap = await db!
        .query('orders', where: 'id = ?', whereArgs: [order.id], limit: 1);

    var orderFound = Order.fromMap(orderMap[0]);

    try {
      await db.transaction((txn) async {
        final batch = txn.batch();
        for (Stock stock in stocks) {
          stock.orderId = orderFound.id;
          batch.insert('stocks', stock.toMap());
        }
        await batch.commit();
      });
    } finally {
      // Close the database after operations
      //await db.close();
    }
  }

  Future<List<Stock>> retrieveStocks(Order order) async {
    final db = _database;

    List<Map<String, dynamic>> orderMap = await db!
        .query('orders', where: 'id = ?', whereArgs: [order.id], limit: 1);

    var orderFound = Order.fromMap(orderMap[0]);

    List<Map<String, dynamic>> stockMaps = await db.query(
      'stocks',
      where: 'order_id = ?',
      whereArgs: [orderFound.id],
    );

    // Convert List<Map<String, dynamic>> to List<Stock>
    return List.generate(stockMaps.length, (index) {
      return Stock(
        orderId: stockMaps[index]['order_id'],
        price: stockMaps[index]['price'],
        quantity: stockMaps[index]['quantity'],
        arrivedDate: stockMaps[index]['quantity'],
        status: stockMaps[index]['quantity'],
      );
    });
  }
}
