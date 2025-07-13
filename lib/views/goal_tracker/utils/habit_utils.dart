import 'package:learnmate/views/goal_tracker/models/habit.dart';

bool isTodaysHabitCompleted(List<DateTime> completedDays){
  DateTime today = DateTime.now();
  return completedDays.any((date)=>
    date.day == today.day &&
    date.month == today.month &&
    date.day == today.day
  );
}


//  first we have to prepare the heat map datasets because the heat
// accepts data in the form of Map<DateTime,int>

Map<DateTime,int> heatMapDatasets(List<Habit> habits) {
  Map<DateTime, int> datasets = {};

  for(Habit habit in habits){
    for(var date in habit.completedDates){
      // normalize the date to avoid time mismatch
      final normalizedDate = DateTime(date.year,date.month,date.day);
      // if this normalizedDate already exist in heatmap then increment the count
      if(datasets.containsKey(normalizedDate)){
        datasets[normalizedDate] = datasets[normalizedDate]!+1;
      }
      // else if it not exist then add it to the heatmap with count 1
      else{
        datasets[normalizedDate] = 1;
      }
    }
  }
  return datasets;


}