import 'package:flutter_riverpod/legacy.dart';
import 'package:note_app/model/model.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

Future<sql.Database> opendatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = sql.openDatabase(
    path.join(dbpath, 'todos.db'),
    onCreate: (db, version) => db.execute(
      'CREATE TABLE user_todos(id TEXT PRIMARY KEY,body TEXT,isdone INTEGER)',
    ),
    version: 1,
  );
  return db;
}

class Todos extends StateNotifier<List<Model>> {
  Todos() : super([]);

  Future<void> loadToDOsFormDataBase() async {
    final sql.Database db = await opendatabase();
    final List<Map<String, Object?>> data = await db.query('user_todos');
    final List<Model> model = data
        .map(
          (item) => Model(
            id: item['id'] as String,
            body: item['body'] as String,
            isdone: item['isdone'] == 'false',
          ),
        )
        .toList();
    state = model;
  }

  addnewitem(String body, bool isdone) async {
    final newItem = Model(body: body, isdone: isdone);
    await syspath.getApplicationDocumentsDirectory();
    final db = await opendatabase();
    await db.insert('user_todos', {
      'id': newItem.id,
      'body': newItem.body,
      'isdone': newItem.isdone ? 1 : 0,
    });

    state = [newItem, ...state];
  }

  removetodo(String id) async {
    final db = await opendatabase();
    db.delete('user_todos', where: 'id=?', whereArgs: [id]);
    state = state.where((item) => item.id != id).toList();
  }

  Future<void> editTodo(String id, String body, bool done) async {
    final db = await opendatabase();
    db.update(
      'user_todos',
      {'body': body, 'isdone': done},
      where: 'id=?',
      whereArgs: [id],
    );
    state = state.map((item) {
      if (item.id == id) {
        return Model(id: id, body: body, isdone: done);
      }
      return item;
    }).toList();
  }
}

final todosnotifier = StateNotifierProvider<Todos, List<Model>>((ref) {
  return Todos();
});
