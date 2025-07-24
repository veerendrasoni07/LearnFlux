import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/views/goal_tracker/components/heat_map.dart';
import 'package:learnmate/views/goal_tracker/database/habit_database.dart';
import 'package:learnmate/views/goal_tracker/models/habit.dart';
import 'package:learnmate/views/goal_tracker/utils/habit_tile.dart';
import 'package:learnmate/views/goal_tracker/utils/habit_utils.dart';

class HabitHomePage extends ConsumerStatefulWidget {
  const HabitHomePage({super.key});

  @override
  ConsumerState<HabitHomePage> createState() => _HabitHomePageState();
}

class _HabitHomePageState extends ConsumerState<HabitHomePage> {

  TextEditingController habitController = TextEditingController();

  void showDialogBox()async{
    showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitController,
                decoration: InputDecoration(
                  hintText: "Enter Your Goal",
                  hintStyle: GoogleFonts.aBeeZee(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.7,
                    height: 1.5
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: ()=>Navigator.pop(context),
                    style:ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      )
                    ) ,
                    child: Text('Cancel'),
                  ),
                  SizedBox(width:10,),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                      shadowColor: WidgetStateProperty.all(Colors.black),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ))
                    ),
                      onPressed: ()async{
                        await ref.read(habitProvider.notifier).addHabit(habitController.text);
                        habitController.clear();
                        Navigator.pop(context);
                      },
                      child: Text('Save')
                  )
                ],
              )
            ],
          ),
        )
    );
  }
  void checkHabitOnOff(bool? value,int id){
    ref.read(habitProvider.notifier).updateTheHabitCompletion(id, value!);
  }


  final TextEditingController habitNameController = TextEditingController();


  void editHabitName(int id,String currentHabit)async{
    habitNameController.text = currentHabit;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_)=>AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: habitNameController,
                decoration: InputDecoration(
                    hintText: "Enter Your Goal",
                    hintStyle: GoogleFonts.aBeeZee(
                        fontSize: 20,
                    )
                )
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: ()=>Navigator.pop(context),
                    style:ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        )
                    ) ,
                    child: Text('Cancel'),
                  ),
                  SizedBox(width:10,),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.green),
                          shadowColor: WidgetStateProperty.all(Colors.black),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ))
                      ),
                      onPressed: ()async{
                        await ref.read(habitProvider.notifier).updateHabitName(id, habitNameController.text.trim());
                        Navigator.pop(context);
                      },
                      child: Text('Save')
                  )
                ],
              )
            ],
          ),
        )
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(habitProvider.notifier).fetchAllHabit();
  }
  
  @override
  Widget build(BuildContext context) {
    final habit = ref.watch(habitProvider);
    List<Habit> currentHabits = habit.currentHabits;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new)),
        title: Text('Habit Tracker',style: GoogleFonts.montserrat(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 1.7,
          height: 2.5
        ),),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.transparent,
      ),
      body:ListView(
        children: [
          _buildHeatMap(),
          ListView.builder(
              itemCount: currentHabits.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              itemBuilder: (context,index){
                final habit = currentHabits[index];
                final isCompletedToday = isTodaysHabitCompleted(habit.completedDates);
                return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context)=>ref.read(habitProvider.notifier).deleteHabit(habit.id),
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      )
                    ]
                  ),
                  child: HabitTile(
                      onChanged: (value)=>checkHabitOnOff(value, habit.id),
                      text: habit.habitName.toString(),
                      isCompletedToday: isCompletedToday,
                    onEdit: ()async{
                        return editHabitName(habit.id,habit.habitName!);
                    } ,
                  ),
                );
              }
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
          clipBehavior: Clip.hardEdge,
          onPressed: (){
            return showDialogBox();
          },
          child:  Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSurface
          )
      ),
    );
  }

  Widget _buildHeatMap(){
    final habitDataBase = ref.watch(habitProvider);
    return FutureBuilder<DateTime?>(
        future: habitDataBase.getFirstLaunchDate(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Error Occurred : ${snapshot.error}"),);
          }
          else if(!snapshot.hasData || snapshot.data == null ){
            return Center(child: Text("No Data "),);
          }
          else{
            return HabitHeatMap(
                startDate: snapshot.data!,
                datasets: heatMapDatasets(habitDataBase.currentHabits)
            );
          }
        }
    );
  }


}
