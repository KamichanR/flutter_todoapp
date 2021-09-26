import 'package:flutter/material.dart';
import 'package:todoapp/pages/tasks_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const TasksPage(),
    );
  }
}
