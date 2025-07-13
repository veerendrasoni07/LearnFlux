import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<ThemeMode>{
  ThemeProvider():super(ThemeMode.light);

  void toggleTheme(){
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => state == ThemeMode.dark;

}

final themeProvider = StateNotifierProvider<ThemeProvider,ThemeMode>((ref)=>ThemeProvider());