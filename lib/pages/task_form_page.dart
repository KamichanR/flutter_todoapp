import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskFormPage extends StatelessWidget {
  final String? name;
  final int? priority;
  final DateTime? deadline;
  final String? memo;
  final ValueChanged<String> onChangedName;
  final ValueChanged<int> onChangedPriority;
  final ValueChanged<DateTime> onChangedDeadline;
  final ValueChanged<String> onChangedMemo;

  const TaskFormPage({
    Key? key,
    this.name,
    this.priority = 3,
    this.deadline,
    this.memo = '',
    required this.onChangedName,
    required this.onChangedPriority,
    required this.onChangedDeadline,
    required this.onChangedMemo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildName(),
          buildPriority(),
          buildDeadline(context),
          buildMemo(),
        ],
      ),
    );
  }

  Widget buildName() {
    return TextFormField(
      maxLines: 1,
      initialValue: name,
      decoration: const InputDecoration(
        hintText: 'タスク名を入力しください',
      ),
      validator: (name) => name != null && name.isEmpty ? 'タスク名は入力必須です' : null,
      onChanged: onChangedName,
    );
  }

  Widget buildPriority() {
    return Row(
      children: [
        const Text('優先度'),
        Expanded(
          child: Slider(
            value: (priority ?? 3).toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (priority) => onChangedPriority(priority.toInt()),
          ),
        ),
        Text('$priority'),
      ],
    );
  }

  Widget buildDeadline(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('期限'),
        Expanded(
          child: TextButton(
            child: Text(DateFormat('yyyy/MM/dd HH:mm').format(deadline!)),
            onPressed: () {
              showDeadlinePicker(context);
            },
          ),
        ),
      ],
    );
  }

  void showDeadlinePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoDatePicker(
            initialDateTime: deadline,
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime.now().add(const Duration(days: 365) * -1),
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            use24hFormat: true,
            onDateTimeChanged: onChangedDeadline,
          ),
        );
      },
    );
  }

  Widget buildMemo() {
    return TextFormField(
      maxLines: 10,
      initialValue: memo,
      decoration: const InputDecoration(
        hintText: 'メモ欄',
      ),
    );
  }
}
