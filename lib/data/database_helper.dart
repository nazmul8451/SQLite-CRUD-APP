import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB_Helper{
  static Database? _db;// ekhaen db holo ekta database connection
static Future<Database> initDB() async{
  final path = join(await getDatabasesPath(), 'todo.db');// phone e folder e database rakhar jonno zei folder thake tar path ber kore ane
  return openDatabase(
      path,
      version: 1,
      onCreate: (db,version)async{
        await db.execute('''CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isComplete INTEGER
        )''');
  });
}
// db যদি তইরি না থাকে তাহলে সে InitDB() function use korbe ar ekta database create korbe
static Future<Database> get database async {
  return _db ??= await initDB();
}

//task insert function
//eta clear
static Future<int> taskInsert(Map<String,dynamic> task )async{
  final db = await database;
  return await db.insert("task", task);
}

//read task function
static Future<List<Map<String,dynamic>>> getAllTasks() async {
  final db = await database;
  return db.query('task',);
}

}