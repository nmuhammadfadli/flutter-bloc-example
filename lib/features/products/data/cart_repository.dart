import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'cart_item_model.dart';
import 'product_model.dart';

class CartRepository {
  static const _tableName = 'cart_items';
  Database? _database;

  Future<Database> get _db async {
    if (_database != null) return _database!;

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'flutter_bloc_demo.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTable(db);
      },
      onOpen: (db) async {
        await _createTable(db);
      },
    );

    return _database!;
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        productId INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        image TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  Future<List<CartItem>> loadCartItems() async {
    final db = await _db;
    final maps = await db.query(_tableName, orderBy: 'rowid DESC');
    return maps.map(_fromMap).toList();
  }

  Future<List<CartItem>> addOrIncrement(ProductModel product) async {
    final db = await _db;
    final existing = await db.query(
      _tableName,
      where: 'productId = ?',
      whereArgs: [product.id],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert(
        _tableName,
        _toMap(CartItem.fromProduct(product)),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      final current = _fromMap(existing.first);
      await db.update(
        _tableName,
        _toMap(current.copyWith(quantity: current.quantity + 1)),
        where: 'productId = ?',
        whereArgs: [product.id],
      );
    }

    return loadCartItems();
  }

  Future<List<CartItem>> incrementQuantity(int productId) async {
    final db = await _db;
    final current = await _findById(db, productId);
    if (current != null) {
      await db.update(
        _tableName,
        _toMap(current.copyWith(quantity: current.quantity + 1)),
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }
    return loadCartItems();
  }

  Future<List<CartItem>> decrementQuantity(int productId) async {
    final db = await _db;
    final current = await _findById(db, productId);
    if (current == null) return loadCartItems();

    if (current.quantity <= 1) {
      await db.delete(_tableName, where: 'productId = ?', whereArgs: [productId]);
    } else {
      await db.update(
        _tableName,
        _toMap(current.copyWith(quantity: current.quantity - 1)),
        where: 'productId = ?',
        whereArgs: [productId],
      );
    }

    return loadCartItems();
  }

  Future<List<CartItem>> removeItem(int productId) async {
    final db = await _db;
    await db.delete(_tableName, where: 'productId = ?', whereArgs: [productId]);
    return loadCartItems();
  }

  Future<List<CartItem>> clearCart() async {
    final db = await _db;
    await db.delete(_tableName);
    return const [];
  }

  Future<CartItem?> _findById(Database db, int productId) async {
    final rows = await db.query(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromMap(rows.first);
  }

  CartItem _fromMap(Map<String, Object?> map) {
    return CartItem(
      productId: map['productId'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }

  Map<String, Object?> _toMap(CartItem item) {
    return {
      'productId': item.productId,
      'title': item.title,
      'image': item.image,
      'category': item.category,
      'price': item.price,
      'quantity': item.quantity,
    };
  }
}
