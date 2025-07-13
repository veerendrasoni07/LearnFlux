import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:learnmate/views/goal_tracker/models/app_setting.dart';
import 'package:learnmate/views/goal_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';


final habitProvider = ChangeNotifierProvider<HabitDataBase>((ref)=>HabitDataBase());

class HabitDataBase extends ChangeNotifier{
  static late Isar isar;

  /*

  SET UP

  */


  // I N I T I A L I S E - D A T A B A S E
  static Future<void> initialize()async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [HabitSchema,AppSettingSchema],
        directory: dir.path
    );
  }


  // Save first data of app startup(for heatmap)
  static Future<void> saveFirstLaunchDate()async{
    final existingSetting = await isar.appSettings.where().findFirst();
    if(existingSetting==null){
      final setting = AppSetting()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(()=>isar.appSettings.put(setting));
    }
  }

  // get first data of app startup(for heatmap)
  Future<DateTime?> getFirstLaunchDate()async{
    final setting = await isar.appSettings.where().findFirst();
    return setting?.firstLaunchDate;
  }


    // C R U D - O P E R A T A I O N S

  // List of habits
  List<Habit> currentHabits = [];

  // Create a new habit
  Future<void> addHabit(String habitName)async{
    // create a new habit
    final habit = Habit()..habitName = habitName;
    // save to db
    await isar.writeTxn(()=>isar.habits.put(habit));
    // re-read from db
    fetchAllHabit();
  }

  // R E A D - saved habits from the db
  Future<void> fetchAllHabit()async{
    // fetch all habit from the db
    List<Habit> allHabits = await isar.habits.where().findAll();
    // update the current habits
    currentHabits.clear();
    currentHabits.addAll(allHabits);
    // update the ui
    notifyListeners();
  }


  // U P D A T E - update the habit
  Future<void> updateTheHabitCompletion(int id,bool isCompleted)async{
    // find the specific habit
    final habit = await isar.habits.get(id);
    // update completion status
    if(habit!=null){
      await isar.writeTxn(()async{
        // if the habit is completed then add the current date to the completedDay list
        if(isCompleted && !habit.completedDates.contains(DateTime.now())){
          // today
          DateTime today = DateTime.now();
          habit.completedDates.add(
            DateTime(
              today.year,
              today.month,
              today.day
            )
          );
        }
        // if habit is not completed then remove the current date from the list
        else{
          // remove the current date if habit is marked as not completed
          habit.completedDates.removeWhere((date)=>
          date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day
          );
        }
        // save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }
    // re - read from db
    fetchAllHabit();
  }

  // U P D A T E - update the name of habit
  Future<void> updateHabitName(int id,String newHabitName)async{
    final habit = await isar.habits.get(id);
    // update name
    if(habit!=null){
      // update name
      isar.writeTxn(()async{
        habit.habitName = newHabitName;
        // save updated habitName back to the db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    fetchAllHabit();
  }

  // D E L E T E - delete the habit
  Future<void> deleteHabit(int id)async{
    final habit = await isar.habits.get(id);
    if(habit!=null){
      await isar.writeTxn(()async{
        await isar.habits.delete(id);
      });
    }
    // re-read from db
    fetchAllHabit();
  }

}