import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/provider/navbar_provider.dart';
import 'package:note_app/screens/notes.dart';
import 'package:note_app/screens/todos.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageindex = ref.watch(navbarnotifier);
    final screens = [const Notes(), const ToDos()];

    return Scaffold(
      body: screens[pageindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,

        onTap: (index) {
          ref.read(navbarnotifier.notifier).selectpage(index);
        },
        currentIndex: pageindex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'To-dos',
          ),
        ],
      ),
    );
  }
}
