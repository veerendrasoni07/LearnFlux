import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/provider/subject_provider.dart';

class ChapterWidget extends ConsumerWidget {
  final String title;
  final IconData icon;
  const ChapterWidget({super.key,required this.title,required this.icon});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final subjects = ref.read(subjectProvider);
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Icon(icon,color: Colors.white)),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
