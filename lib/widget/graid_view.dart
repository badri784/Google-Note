import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/provider/note_provider.dart';

class GraidViewWidget extends ConsumerStatefulWidget {
  const GraidViewWidget({super.key});

  @override
  ConsumerState<GraidViewWidget> createState() => _GraidViewWidgetState();
}

class _GraidViewWidgetState extends ConsumerState<GraidViewWidget> {
  @override
  Widget build(BuildContext context) {
    final item = ref.watch(noteNotifier);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: item.length,
      itemBuilder: (context, index) {
        return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item[index].title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  item[index].body,
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                  overflow: TextOverflow.fade,
                  maxLines: 8,
                ),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Icon(Icons.delete, size: 18, color: Colors.redAccent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
