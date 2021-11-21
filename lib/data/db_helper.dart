import 'dart:async';
import 'package:notebook/models/note_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _db;
  Future<Database?> get db async {
    _db ??= await initializeDb();
    return _db;
  }

  //Initiliaze Database
  Future<Database?> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), 'etrade.db');
    var eTradeDb = openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  //Create Database
  FutureOr<void> createDb(Database db, int version) async {
    await db.execute(
        "Create table notes(id integer primary key,title text,description text, datetime text,url text)");
  }

  //Get Data
  Future<List<NoteVM>>? getNotes() async {
    Database? db = await this.db;
    var result = await db!.query('notes');
    return List.generate(
        result.length, (index) => NoteVM.fromJson(result[index]));
  }

  //Insert Method
  Future<int?> insert(NoteVM note) async {
    Database? db = await this.db;
    var result = await db!.insert('notes', note.toJson());
  }

  //Delete Method
  Future<int?> delete(NoteVM note) async {
    Database? db = await this.db;
    var result = await db!.delete('notes', where: 'id=?', whereArgs: [note.id]);
  }

  //Update Method
  Future<int?> update(NoteVM note) async {
    Database? db = await this.db;
    var result = await db!
        .update('notes', note.toJson(), where: 'id=?', whereArgs: [note.id]);
  }
}
