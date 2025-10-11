import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/note_model.dart';
import 'package:note_app/screens/edit_Folder/edit_note_screen.dart';

class OpenNoteScreen extends ConsumerWidget {
  const OpenNoteScreen({required this.note, super.key});
  final NoteModel note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Your Note',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(3, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const Divider(),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: note.body));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Your note was copied ✅'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Cancel',
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: ''));
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    note.body,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[400],
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)));
        },
        label: const Text(
          'Edit Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.edit_note_rounded),
      ),
    );
  }
}
