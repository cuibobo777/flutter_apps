import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  // isar
  static late Isar isar;

  // 设置

  // 初始化数据库
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // 保存app启动时的首部分数据
  Future<void> saveFirstLaunchDate() async {
    // 判断是否存在首次打开时间
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // 获取app启动时的首部分数据
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLunchDate;
  }

  // 增删改查

  // list
  final List<Habit> currentHabits = [];

  // 增
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;

    // 存入数据库
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // 重新读取
    readHabits();
  }

  // 查
  Future<void> readHabits() async {
    // 获取所有的habit
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // 更新当前habit列表
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // 通知更新
    notifyListeners();
  }

  // 改
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // 更新数据库
    final habit = await isar.habits.get(id);

    // 更新状态
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.complateDays.contains(DateTime.now())) {
          // 获取当前日期
          final today = DateTime.now();

          // 更新habit的时间
          habit.complateDays.add(
            DateTime(today.year, today.month, today.day),
          );
        } else {
          habit.complateDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }

        // 保存
        await isar.habits.put(habit);
      });
    }

    // 重新读取
    readHabits();
  }

  // 删除
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // 重新读取
    readHabits();
  }
}
