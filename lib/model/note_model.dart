import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class NoteModel {
  NoteModel({String? id, required this.title, required this.body})
    : id = id ?? uuid.v4();
  final String title;
  final String body;
  final String id;
}
