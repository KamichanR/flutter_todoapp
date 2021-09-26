import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/database/task_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/pages/edit_task_page.dart';

class ReadTaskPage extends StatefulWidget {
  final int taskId;

  const ReadTaskPage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  _ReadTaskPageState createState() => _ReadTaskPageState();
}

class _ReadTaskPageState extends State<ReadTaskPage> {
  late Task task;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future loadTask() async {
    setState(() => isLoading = true);
    task = await TaskHelper.instance.readTask(widget.taskId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                    task: task,
                  ),
                ),
              );
              loadTask();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              await TaskHelper.instance.deleteTask(widget.taskId);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${task.priority}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            task.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: const Text('期限'),
                    color: Colors.grey[300],
                    height: 20,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat('yyyy/MM/dd HH:mm').format(task.deadline),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    padding: const EdgeInsets.all(5.0),
                  ),
                  Container(
                    child: const Text('メモ'),
                    color: Colors.grey[300],
                    height: 20,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(task.memo),
                  )
                ],
              ),
            ),
    );
  }
}
