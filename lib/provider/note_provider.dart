import 'package:flutter_riverpod/legacy.dart';
import 'package:note_app/model/note_model.dart';

class NoteProvider extends StateNotifier<List<NoteModel>> {
  NoteProvider() : super([]);

  void addnote(String title, String body) {
    final newItem = NoteModel(title: title, body: body);
    state = [newItem, ...state];
  }

  void removeNote(String id) {
    state = state.where((item) => item.id == id).toList();
  }
}

final noteNotifier = StateNotifierProvider<NoteProvider, List<NoteModel>>(
  (ref) => NoteProvider(),
);
