import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class Model {
  Model({String? id, required this.body, required this.isdone})
    : id = id ?? uuid.v4();
  final String id;
  final String body;
  final bool isdone;
}
