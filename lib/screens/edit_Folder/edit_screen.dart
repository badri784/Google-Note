import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/provider/todos_provider.dart';

class EditTodosScreen extends ConsumerStatefulWidget {
  const EditTodosScreen({super.key, required this.model});

  final Model model;
  @override
  ConsumerState<EditTodosScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditTodosScreen> {
  late TextEditingController textEditingController;
  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  void onsave() {
    final bool isdone = false;
    final text = textEditingController.text;
    if (text.isEmpty) return;
    ref.read(todosnotifier.notifier).editTodo(widget.model.id, text, isdone);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.model.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Screen'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Edit Todo :',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                keyboardType: TextInputType.text,
                controller: textEditingController,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onsave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
