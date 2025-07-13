import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/provider/subject_provider.dart';

class SubjectWidget extends ConsumerWidget {
  final String title;
  final IconData icon;
  const SubjectWidget({super.key,required this.title,required this.icon});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final subjects = ref.read(subjectProvider);
    return Container(
      height: 180,
      width: 180,
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
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Icon(icon,color: Colors.white)),
          ),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          )
        ],
      ),
    );
  }
}
