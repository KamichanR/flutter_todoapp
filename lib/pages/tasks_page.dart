import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/database/task_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/pages/edit_task_page.dart';
import 'package:todoapp/pages/read_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    TaskHelper.instance.closeDatabase();
    super.dispose();
  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    tasks = await TaskHelper.instance.readAllTasks();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo管理アプリ'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = tasks[index];
                  return Card(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  task.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('期限：'),
                                    Text(DateFormat('yyyy/MM/dd HH:mm')
                                        .format(task.deadline)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${task.priority}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ReadTaskPage(taskId: task.id!),
                          ),
                        );
                        loadTasks();
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          child: const Icon(Icons.add),
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.red,
              ],
            ),
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EditTaskPage()),
          );
          loadTasks();
        },
      ),
    );
  }
}
