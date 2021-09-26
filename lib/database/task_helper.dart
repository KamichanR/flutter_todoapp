import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task.dart';

const String databaseName = 'tasks.db';
const String tableName = 'tasks';

const String columnId = '_id';
const String columnName = 'name';
const String columnPriority = 'priority';
const String columnDeadline = 'deadline';
const String columnMemo = 'memo';

const List<String> columns = [
  columnId,
  columnName,
  columnPriority,
  columnDeadline,
  columnMemo,
];

class TaskHelper {
  static final TaskHelper instance = TaskHelper._createInstance();
  static Database? _database;

  TaskHelper._createInstance();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database database, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String intType = 'INTEGER NOT NULL';
    const String textType = 'TEXT NOT NULL';
    const String textNullType = 'TEXT';

    await database.execute('''
      CREATE TABLE $tableName (
        $columnId $idType,
        $columnName $textType,
        $columnPriority $intType,
        $columnDeadline $textType,
        $columnMemo $textNullType
      )
    ''');
  }

  Future createTask(Task task) async {
    final database = await instance.database;
    await database.insert(tableName, task.toJson());
  }

  Future<Task> readTask(int id) async {
    final database = await instance.database;
    final taskMaps = await database.query(
      tableName,
      columns: columns,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (taskMaps.isNotEmpty) {
      return Task.fromJson(taskMaps.first);
    } else {
      throw Exception('id: $id not found.');
    }
  }

  Future<List<Task>> readAllTasks() async {
    final database = await instance.database;
    const orderBy = '$columnDeadline ASC';
    final tasksMapsList = await database.query(
      tableName,
      orderBy: orderBy,
    );

    return tasksMapsList.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final database = await instance.database;

    return database.update(
      tableName,
      task.toJson(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final database = await instance.database;

    return await database.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future closeDatabase() async {
    final database = await instance.database;

    database.close();
  }
}
