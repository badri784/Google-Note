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
    final List<NoteModel> model = data
        .map(
          (item) => NoteModel(
            title: item['title'] as String,
            body: item['body'] as String,
          ),
        )
        .toList();
    state = model;
  }

  Future<void> addnote(String title, String body) async {
    final newItem = NoteModel(title: title, body: body);
    final db = await opendatabase();
    await syspath.getApplicationDocumentsDirectory();
    db.insert('user_note', {
      'id': newItem.id,
      'title': newItem.title,
      'body': newItem.body,
    });
    state = [newItem, ...state];
  }

  editNoteIte(String id, String body, String title) {
    state = state.map((item) {
      if (item.id == id) {
        return NoteModel(title: title, body: body);
      }
      return item;
    }).toList();
  }

  removeNote(String id) async {
    final sql.Database db = await opendatabase();
    db.delete('user_note', where: 'id==?', whereArgs: [id]);
    state = state.where((item) => item.id != id).toList();
  }
}

final noteNotifier = StateNotifierProvider<NoteProvider, List<NoteModel>>(
  (ref) => NoteProvider(),
);
