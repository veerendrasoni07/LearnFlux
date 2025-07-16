import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/views/screens/main_screen.dart';

class HabitHomeDrawer extends StatelessWidget {
  const HabitHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Habit Tracker",
              style: GoogleFonts.albertSans(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 2,
              height: 2.5
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary
              ),
              child: ListTile(
                leading: Icon(
                    Icons.home,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                title: Text(
                  'Home',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                    height: 2
                  ),
                ),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
