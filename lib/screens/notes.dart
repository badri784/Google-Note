import 'package:flutter/material.dart';
import 'package:note_app/screens/edit_Folder/add_note_screen.dart';
import 'package:note_app/widget/graid_view.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NoteScreen()));
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.amber,
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 2,
            scrolledUnderElevation: 10,

            flexibleSpace: const Padding(
              padding: EdgeInsets.only(bottom: 10, left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    fontFamily: 'cairo',
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, size: 30),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 27),
              ),
            ],
            actionsPadding: const EdgeInsets.all(12),
            floating: true,
            expandedHeight: 110,
            bottom: TabBar(
              indicatorWeight: 1,
              dividerColor: Colors.transparent,
              isScrollable: true,
              controller: tabController,
              tabs: const [
                Tab(icon: Icon(Icons.view_sidebar)),
                Tab(child: Text('All notes')),
                Tab(child: Text('Handwritten Notes')),
                Tab(child: Text('Default notebook')),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: const [
            Center(child: Text('Content of Tab 12')),
            GraidViewWidget(),
            Center(child: Text('Content of Tab 3')),
            GraidViewWidget(),
          ],
        ),
      ),
    );
  }
}
