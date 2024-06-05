// 每天完成的爱好列表
// 今天是否完成
bool isHabitCompletedTody(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}
