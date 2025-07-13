import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HabitHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime,int> datasets;
  const HabitHeatMap({super.key,required this.startDate,required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      showColorTip: false,
      startDate: startDate,
      datasets: datasets,
      scrollable: true,
      showText: true,

      size: 36,
      colorMode: ColorMode.color,
      defaultColor: Colors.grey.shade400,
      colorsets: {
        1:Colors.green.shade200,
        2:Colors.green.shade300,
        3:Colors.green.shade400,
        4:Colors.green.shade500,
        5:Colors.green.shade700,
        6:Colors.green.shade800,
        7:Colors.green.shade900,
      },
    );
  }
}
