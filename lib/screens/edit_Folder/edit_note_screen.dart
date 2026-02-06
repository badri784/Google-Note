import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/note_model.dart';
import '../../provider/note_provider.dart';
import '../add_screen/add_note_screen.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  const EditNoteScreen({required this.note, super.key});
  final NoteModel note;

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  late TextEditingController titleEditingController;
  late TextEditingController bodyEdititngController;

  @override
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
    bodyEdititngController.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(text: widget.note.title);
    bodyEdititngController = TextEditingController(text: widget.note.body);
  }

  @override
  Widget build(BuildContext context) {
    void onsave() {
      final title = titleEditingController.text;
      final body = bodyEdititngController.text;
      if (title.isEmpty || body.isEmpty) return;
      ref.read(noteNotifier.notifier).editNoteIte(widget.note.id, title, body);
      Navigator.of(context).pop(true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Note'),
        actions: [IconButton(onPressed: onsave, icon: const Icon(Icons.done))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleEditingController,
                  autocorrect: true,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'title :',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomPaint(
                    painter: LinedPaperPainter(),
                    child: TextField(
                      autofocus: true,
                      controller: bodyEdititngController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start typing your note...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 18, height: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
