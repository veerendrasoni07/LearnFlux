
import 'package:flutter/material.dart' ;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitTile extends ConsumerWidget {
  final String text;
  final bool isCompletedToday;
  void Function(bool?) onChanged;
  HabitTile({super.key,required this.onChanged,required this.text,required this.isCompletedToday});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            decoration: BoxDecoration(
              color: isCompletedToday ? Colors.green : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              style: ListTileStyle.drawer,
              title: Text(text,style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.7,
                height: 2.5
              ),),
              leading: Checkbox(
                activeColor: Colors.green,
                  value: isCompletedToday,
                  onChanged: onChanged
              ),
            ),
          );
      }
}
