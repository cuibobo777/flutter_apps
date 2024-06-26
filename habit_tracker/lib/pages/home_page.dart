import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/uitl/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: '创建一个新的爱好'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: [
          // 保存
          MaterialButton(
            onPressed: () {
              // 获取输入的爱好
              String newHabitName = textController.text;
              // 保存至isar
              context.read<HabitDatabase>().addHabit(newHabitName);
              // 关闭弹窗
              Navigator.of(context).pop();
              // 清除输入内容
              textController.clear();
            },
            child: const Text('保存'),
          ),
          // 取消
          MaterialButton(
            onPressed: () {
              // 关闭弹窗
              Navigator.of(context).pop();
              // 清除输入内容
              textController.clear();
            },
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  // 修改爱好名字
  void editHabitBox(Habit habit) {
    // 获取新名字
    textController.text = habit.name;

    // 弹窗
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // 保存
          MaterialButton(
            onPressed: () {
              // 获取输入的爱好
              String newHabitName = textController.text;
              // 保存至isar
              context.read<HabitDatabase>().updateHabitName(
                    habit.id,
                    newHabitName,
                  );
              // 关闭弹窗
              Navigator.of(context).pop();
              // 清除输入内容
              textController.clear();
            },
            child: const Text('保存'),
          ),
          // 取消
          MaterialButton(
            onPressed: () {
              // 关闭弹窗
              Navigator.of(context).pop();
              // 清除输入内容
              textController.clear();
            },
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  // 删除爱好
  void deleteHabitBox(Habit habit) {
    // 弹窗
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认要删除当前爱好么'),
        actions: [
          // 保存
          MaterialButton(
            onPressed: () {
              // isar删除
              context.read<HabitDatabase>().deleteHabit(habit.id);
              // 关闭弹窗
              Navigator.of(context).pop();
            },
            child: const Text('删除'),
          ),
          // 取消
          MaterialButton(
            onPressed: () {
              // 关闭弹窗
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    // 更新爱好的完成状态
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    // 爱好数据
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    // 爱好数据
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedTody(habit.complateDays);

        return ListTile(
          title: MyHabitTile(
            habitName: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit),
          ),
        );
      },
    );
  }
}
