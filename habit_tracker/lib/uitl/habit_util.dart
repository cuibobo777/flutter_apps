// 每天完成的爱好列表
// 今天是否完成
import '../models/habit.dart';

bool isHabitCompletedTody(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// 构建热图数据
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.complateDays) {
      final normalizeDate = DateTime(date.year, date.month, date.day);

      // 如果时间在完成时间列表里， 加一
      if (dataset.containsKey(normalizeDate)) {
        dataset[normalizeDate] = dataset[normalizeDate]! + 1;
      } else {
        dataset[normalizeDate] = 1;
      }
    }
  }

  return dataset;
}
