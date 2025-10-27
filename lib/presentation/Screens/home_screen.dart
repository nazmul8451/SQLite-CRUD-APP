import 'package:flutter/material.dart';
import 'package:sqlite_crud_project/data/database_helper.dart';

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
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: desController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await addTask();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Rimon Islam',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const Text(
              'Good Evening',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text(
                  'No Notes yet!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  bool isCompleted = task['isComplete'] == 1;
                  return Card(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (value) async {
                          await DB_Helper.updateTaskStatus(
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
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        task['description'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DB_Helper.deleteTask(task['id']);
                          loadTask();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
