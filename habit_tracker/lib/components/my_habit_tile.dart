import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String habitName;
  final void Function(bool?)? onChanged;
  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.habitName, // 添加required修饰符
    required this.onChanged, // 添加required修饰符
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCompleted
              ? Colors.green
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: ListTile(
        title: Text(habitName),
        leading: Checkbox(
          onChanged: onChanged,
          value: isCompleted,
        ),
      ),
    );
  }
}
