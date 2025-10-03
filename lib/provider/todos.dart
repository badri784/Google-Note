import 'package:flutter_riverpod/legacy.dart';
import 'package:note_app/model/model.dart';

class Todos extends StateNotifier<List<Model>> {
  Todos() : super([]);

  void addnewitem(String body, bool iscom) {
    final item = Model(body: body, iscompleate: iscom);
    state = [item, ...state];
  }

  void removetodo(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final todosnotifier = StateNotifierProvider<Todos, List<Model>>((ref) {
  return Todos();
});
