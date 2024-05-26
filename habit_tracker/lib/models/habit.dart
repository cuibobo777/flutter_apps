import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // id
  Id id = Isar.autoIncrement;

  // 爱好名称
  late String name;

  // 完成日期
  List<DateTime> complateDays = [];
}
