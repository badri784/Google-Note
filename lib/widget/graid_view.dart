import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/provider/note_provider.dart';
import 'package:note_app/screens/edit_Folder/edit_note_screen.dart';
import 'package:note_app/screens/open_note_screen.dart';

class GraidViewWidget extends ConsumerStatefulWidget {
  const GraidViewWidget({super.key});

  @override
  ConsumerState<GraidViewWidget> createState() => _GraidViewWidgetState();
}

class _GraidViewWidgetState extends ConsumerState<GraidViewWidget> {
  late Future<void> futureProviderr;
  @override
  void initState() {
    super.initState();
    futureProviderr = ref.read(noteNotifier.notifier).loaddatabase();
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(noteNotifier);

    return FutureBuilder(
      future: futureProviderr,
      builder: (context, asyncSnapshot) =>
          asyncSnapshot.connectionState == ConnectionState.waiting
          ? const CircularProgressIndicator()
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: item.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OpenNoteScreen(note: item[index]),
                      ),
                    );
                  },
                  child: Dismissible(
                    key: Key(item[index].id),
                    onDismissed: (direction) {
                      ref
                          .watch(noteNotifier.notifier)
                          .removeNote(item[index].id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            item[index].title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            item[index].body,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 15,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditNoteScreen(note: item[index]),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(noteNotifier.notifier)
                                      .removeNote(item[index].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
