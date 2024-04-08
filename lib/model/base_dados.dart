import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseDados {
  Future<Database> conectar() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'hello_here.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, version) async {
      await db.execute(''' CREATE TABLE entrada(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      valor REAL,
      nome TEXT,
      dataHora TEXT) ''');
      await db.execute(''' CREATE TABLE saldo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL,
      )''');
      await db.execute(''' CREATE TABLE saida (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL,
        nome TEXT,
        dataHora TEXT
      )''');
    });
  }
}
