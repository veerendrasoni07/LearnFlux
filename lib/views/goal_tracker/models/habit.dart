
import 'package:isar/isar.dart';
part 'habit.g.dart';

@Collection()
class Habit{

  Id id = Isar.autoIncrement;

  String? habitName;

  List<DateTime> completedDates = [];


}