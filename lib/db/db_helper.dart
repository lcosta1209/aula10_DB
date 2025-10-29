import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('clientes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, fileName);

    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE clientes (
codigo INTEGER PRIMARY KEY AUTOINCREMENT,
cpf TEXT NOT NULL,
nome TEXT NOT NULL,
idade INTEGER NOT NULL,
dataNascimento TEXT NOT NULL,
cidadeNascimento TEXT NOT NULL
)
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
