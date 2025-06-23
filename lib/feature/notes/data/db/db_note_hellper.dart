// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:study_hub/feature/notes/data/task_model.dart';

class DbNoteHelper {
  static Database? _db;
  static const int _version = 1;
  static const _tableName = 'notes';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = '${await getDatabasesPath()}note.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,title STRING, note TEXT , color INTEGER)');
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  static Future<int> insert(Note note) async {
    log('inserting to data base');
    return await _db!.insert(_tableName, note.toMap());
  }

  static Future<int> delete(Note note) async {
    log('delete to data base');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<int> deleteAll() async {
    log('delete all data base');
    return await _db!.delete(
      _tableName,
    );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    log('query to data base');
    return await _db!.query(_tableName);
  }

  static Future<int> updateNote(Note note) async {
    log('update to data base');
    return await _db!.update(_tableName, note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }
}
