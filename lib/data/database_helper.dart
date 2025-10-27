import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB_Helper {
  static Database? _db;
  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'todo.db');
    print('Database path: $path');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Database Created');
        await db.execute('''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isComplete INTEGERw
      )
      ''');
      },
    );
  }


  static Future<Database> get database async {
    _db ??= await initDB();
    return _db!;
  }

  //  Insert
  static Future<int> taskInsert(Map<String, dynamic> task) async {
    final db = await database;
    int result = await db.insert("task", task);
    print('Inserted Task: $task with id: $result');
    return result;
  }

  //  Read
  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    final data = await db.query('task');
    print('All Tasks: $data');
    return data;
  }

  //  Update (for checkbox)
  static Future<int> updateTaskStatus(int id, int isComplete) async {
    final db = await database;
    return await db.update(
      'task',
      {'isComplete': isComplete},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //  Delete
  static Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }
}
