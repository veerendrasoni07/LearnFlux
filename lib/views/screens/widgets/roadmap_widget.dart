import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/models/roadmap.dart';
import 'package:markdown_widget/markdown_widget.dart';

class RoadmapWidget extends StatefulWidget {
  final RoadMap roadMap;
  const RoadmapWidget({super.key,required this.roadMap});

  @override
  State<RoadmapWidget> createState() => _RoadmapWidgetState();
}

class _RoadmapWidgetState extends State<RoadmapWidget> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Your RoadMap\nGoal: ${widget.roadMap.goal}!',
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 1.7,
              height: 1.5,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: MarkdownWidget(
              data: widget.roadMap.roadmap,
            shrinkWrap: true,
            config: MarkdownConfig(
              configs: [
                H1Config(
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 2,
                  )
                ),
                H2Config(
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                  )
                ),
                H3Config(
                  style: GoogleFonts.lato(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                  )
                ),
                H4Config(
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                  )
                ),
                H5Config(
                  style: GoogleFonts.lato(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                  )
                ),
                H6Config(
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.7,
                  )
                ),

              ]
            ) ,
          ),
        )
      ],
    );
  }
}
