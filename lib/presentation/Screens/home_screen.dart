import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sqlite_crud_project/data/database_helper.dart';
import 'package:sqlite_crud_project/presentation/widgets/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> loadTask() async {
    tasks = await DB_Helper.getAllTasks();
    setState(() {});
  }

  Future<void> addTask() async {
    String title = titleController.text.trim();
    String description = desController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      await DB_Helper.taskInsert({
        'title': title,
        'description': description,
        'isComplete': 0,
      });
      await loadTask();
      titleController.clear();
      desController.clear();
    }
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C002E),
          title: const Text('Add Task', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: desController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
              onPressed: () async {
                await addTask();
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            'My Todo',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D001F),
                  Color(0xFF210050),
                  Color(0xFF1B0034),
                ],
              ),
            ),
          ),

          // 💜 Glow Circles
          Positioned(
            top: -60,
            left: -30,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -40,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          //Optional blur overlay for smoothness
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Hello, ',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          children: [
                            TextSpan(
                              text: 'Rimon Islam',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.purpleAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Good Morning 🌙',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 10),

                    ],
                  ),
                ),
                const SizedBox(height: 15),

                Expanded(
                  child: tasks.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            bool isCompleted = task['isComplete'] == 1;

                            return Dismissible(
                              key: Key(task['id'].toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: Color(0xFF9f3f32),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (direction) async {
                                await DB_Helper.deleteTask(task['id']);
                                setState(() {
                                  tasks.removeAt(index);
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('Task deleted')));
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: ListTile(
                                    leading: Checkbox(
                                      activeColor: Colors.purpleAccent,
                                      value: isCompleted,
                                      onChanged: (value) async {
                                        await DB_Helper.checkTaskStatus(
                                          task['id'],
                                          value! ? 1 : 0,
                                        );
                                        loadTask();
                                      },
                                    ),
                                    title: Text(
                                      task['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        decoration: isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task['description'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    trailing:
                                        // IconButton(
                                        //   icon: const Icon(
                                        //     Icons.delete_outline,
                                        //     color: Colors.redAccent,
                                        //   ),
                                        //   onPressed: () async {
                                        //     await DB_Helper.deleteTask(task['id']);
                                        //     loadTask();
                                        //   },
                                        // ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_note_outlined,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            TextEditingController
                                            editTitleController =
                                                TextEditingController();
                                            TextEditingController
                                            editDesController =
                                                TextEditingController();
                                            editTitleController.text =
                                                task['title'];
                                            editDesController.text =
                                                task['description'];

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: const Color(
                                                    0xFF1C002E,
                                                  ),
                                                  title: Text(
                                                    'Edit Task',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            editTitleController,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText: 'Title',
                                                          labelStyle:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                              ),
                                                          filled: true,
                                                          fillColor: Colors.white
                                                              .withOpacity(0.1),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      TextField(
                                                        controller:
                                                            editDesController,
                                                        maxLines: 3,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText: '',
                                                          labelStyle:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                              ),
                                                          filled: true,
                                                          fillColor: Colors.white
                                                              .withOpacity(0.1),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context),
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .purpleAccent,
                                                          ),
                                                      onPressed: () async {
                                                        await DB_Helper.updateTask(
                                                          task['id'],
                                                          editTitleController
                                                              .text,
                                                          editDesController.text,
                                                        );
                                                        await loadTask(); // reload tasks
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Update',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
