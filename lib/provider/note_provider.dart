import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:note_app/model/note_model.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

Future<sql.Database> opendatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'note.db'),
    onCreate: (db, version) => db.execute(
      'CREATE TABLE user_note(id TEXT PRIMARY KEY,title TEXT,body TEXT)',
    ),
    version: 1,
  );
  return db;
}

class NoteProvider extends StateNotifier<List<NoteModel>> {
  NoteProvider() : super([]);

  loaddatabase() async {
    final sql.Database db = await opendatabase();
    final List<Map<String, Object?>> data = await db.query('user_note');
    log(data.toString());
    final List<NoteModel> model = data
        .map(
          (item) => NoteModel(
            id: item['id'] as String,
            title: item['title'] as String,
            body: item['body'] as String,
          ),
        )
        .toList();
    state = model;
  }

  Future<void> addnote(String title, String body) async {
    await syspath.getApplicationDocumentsDirectory();
    final newItem = NoteModel(title: title, body: body);
    final db = await opendatabase();
    await db.insert('user_note', {
      'id': newItem.id,
      'title': newItem.title,
      'body': newItem.body,
    });
    log(
      'state in add note provider title : ${newItem.title.toString()}/ body:  ${newItem.body.toString()}',
    );
    state = [newItem, ...state];
  }

  editNoteIte(String id, String title, String body) async {
    final db = await opendatabase();
    await db.update(
      'user_note',
      {'title': title, 'body': body},
      where: 'id=?',
      whereArgs: [id],
    );
    state = state.map((item) {
      if (item.id == id) {
        return NoteModel(title: title, body: body);
      }
      return item;
    }).toList();
  }

  Future<void> removeNote(String id) async {
    final sql.Database db = await opendatabase();
    await db.delete('user_note', where: 'id=?', whereArgs: [id]);
    state = state.where((item) => item.id != id).toList();
    log('note form database ${state.toString()}');
  }
}

final noteNotifier = StateNotifierProvider<NoteProvider, List<NoteModel>>(
  (ref) => NoteProvider(),
);
