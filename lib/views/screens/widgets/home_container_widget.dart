import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContainerWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  const HomeContainerWidget({super.key,required this.title,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
            style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
