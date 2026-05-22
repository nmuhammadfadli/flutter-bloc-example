import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'todo_model.dart';

class TodoRepository {
  static const _tableName = 'todos';
  Database? _database;

  final List<TodoItem> _seed = const [
    TodoItem(id: '1', title: 'Belajar Bloc dasar', isDone: false),
    TodoItem(id: '2', title: 'Latihan fetch API', isDone: true),
  ];

  Future<Database> get _db async {
    if (_database != null) return _database!;
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'flutter_bloc_demo_clean.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            isDone INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<TodoItem>> getTodos() async {
    final db = await _db;
    final maps = await db.query(_tableName, orderBy: 'rowid DESC');

    if (maps.isEmpty) {
      await _insertSeedData(db);
      return _readTodos(db);
    }

    return _mapTodos(maps);
  }

  Future<List<TodoItem>> addTodo(String title) async {
    final db = await _db;
    final todo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
    );
    await db.insert(
      _tableName,
      _toMap(todo),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return _readTodos(db);
  }

  Future<List<TodoItem>> toggleTodo(String id) async {
    final db = await _db;
    final current = await db.query(_tableName, where: 'id = ?', whereArgs: [id], limit: 1);
    if (current.isNotEmpty) {
      final item = _fromMap(current.first);
      await db.update(
        _tableName,
        _toMap(item.copyWith(isDone: !item.isDone)),
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    return _readTodos(db);
  }

  Future<List<TodoItem>> deleteTodo(String id) async {
    final db = await _db;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    return _readTodos(db);
  }

  Future<void> _insertSeedData(Database db) async {
    for (final item in _seed) {
      await db.insert(
        _tableName,
        _toMap(item),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<TodoItem>> _readTodos(Database db) async {
    final maps = await db.query(_tableName, orderBy: 'rowid DESC');
    return _mapTodos(maps);
  }

  List<TodoItem> _mapTodos(List<Map<String, Object?>> maps) {
    return maps.map(_fromMap).toList();
  }

  TodoItem _fromMap(Map<String, Object?> map) {
    return TodoItem(
      id: map['id'] as String,
      title: map['title'] as String,
      isDone: (map['isDone'] as int) == 1,
    );
  }

  Map<String, Object?> _toMap(TodoItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'isDone': item.isDone ? 1 : 0,
    };
  }
}
