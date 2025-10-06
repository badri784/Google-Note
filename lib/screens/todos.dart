import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:note_app/model/model.dart';
import 'package:note_app/provider/todos_provider.dart';
import 'package:note_app/screens/edit_screen.dart';

class ToDos extends ConsumerStatefulWidget {
  const ToDos({super.key});

  @override
  ConsumerState<ToDos> createState() => _ToDosState();
}

class _ToDosState extends ConsumerState<ToDos> {
  TextEditingController textController = TextEditingController();
  bool iscompl = false;

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  DateTime? pickeddate;
  late Future<void> future;
  @override
  void initState() {
    super.initState();
    future = ref.read(todosnotifier.notifier).loadToDOsFormDataBase();
  }

  @override
  Widget build(BuildContext context) {
    final List<Model> item = ref.watch(todosnotifier);
    log(item.toString());
    return Scaffold(
      floatingActionButton: floating(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: const Padding(
              padding: EdgeInsets.only(bottom: 10, left: 30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'To-dos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    fontFamily: 'cairo',
                  ),
                ),
              ),
            ),
            actions: [
              PopupMenuButton<int>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                color: Colors.white,
                onSelected: (value) {
                  if (value == 0) {
                    // Edit
                  } else if (value == 1) {
                    // Delete
                  } else if (value == 2) {
                    // Share
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.share, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
            actionsPadding: const EdgeInsets.all(12),
            floating: true,
            expandedHeight: 110,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return FutureBuilder(
                future: future,
                builder: (context, asyncSnapshot) =>
                    asyncSnapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : Dismissible(
                        key: Key(item[index].id),
                        onDismissed: (direction) => ref
                            .read(todosnotifier.notifier)
                            .removetodo(item[index].id),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card.outlined(
                            child: ListTile(
                              onLongPress: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditScreen(model: item[index]),
                                  ),
                                );
                              },
                              title: Text(item[index].body),
                              leading: Checkbox(
                                shape: const CircleBorder(),
                                value: iscompl,
                                onChanged: (bool? value) {
                                  setState(() {
                                    iscompl = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            }, childCount: item.length),
          ) /*
          if (item.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,

                child: Image.asset(
                  'assets/image/notodo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),*/,
        ],
      ),
    );
  }

  Widget floating() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () {
          modelsheet();
        },
        backgroundColor: Colors.amber,
        shape: const CircleBorder(),
        tooltip: 'add to-dos',
        child: const Icon(Icons.add, size: 40, color: Colors.white),
      ),
    );
  }

  modelsheet() async {
    return showBottomSheet(
      showDragHandle: true,
      backgroundColor: Colors.white54,
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 8),
        height: 200,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  const Text(
                    'New To-do',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'cairo',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final text = textController.text;
                      if (text.isNotEmpty) {
                        ref
                            .read(todosnotifier.notifier)
                            .addnewitem(text, iscompl);
                        textController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                controller: textController,
                // ignore: deprecated_member_use
                scribbleEnabled: true,
                decoration: const InputDecoration(
                  hint: Opacity(opacity: 0.3, child: Text('New to-do')),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatefulBuilder(
                    builder: (context, setState) => TextButton.icon(
                      onPressed: () async {
                        final DateTime firstDate = DateTime(
                          DateTime.now().year - 5,
                        );
                        final DateTime lastDate = DateTime(
                          DateTime.now().year + 5,
                        );
                        final DateTime initialdate = DateTime.now();

                        final date = await showDatePicker(
                          context: context,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          initialDate: initialdate,
                        );
                        log(date.toString());
                        if (date != null) {
                          setState(() {
                            pickeddate = date;
                          });
                        }
                      },

                      icon: const Icon(Icons.alarm_outlined),
                      label: Text(
                        pickeddate == null
                            ? 'Pick your date'
                            : DateFormat.yMd().format(pickeddate!),
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
