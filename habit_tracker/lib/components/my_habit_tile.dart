import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String habitName;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.habitName, // 添加required修饰符
    required this.onChanged, // 添加required修饰符
    required this.editHabit, // 添加required修饰符
    required this.deleteHabit, // 添加required修饰符
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editHabit,
            icon: Icons.settings,
            backgroundColor: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: deleteHabit,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(habitName),
            textColor: isCompleted
                ? Colors.white
                : Theme.of(context).colorScheme.inversePrimary,
            leading: Checkbox(
              activeColor: Colors.green,
              onChanged: onChanged,
              value: isCompleted,
            ),
          ),
        ),
      ),
    );
  }
}
