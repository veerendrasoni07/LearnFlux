import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/provider/theme_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/theme/dark_mode.dart';
import 'package:learnmate/theme/light_theme.dart';
import 'package:learnmate/views/goal_tracker/database/habit_database.dart';
import 'package:learnmate/views/screens/authentication/on_boarding_screen.dart';
import 'package:learnmate/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDataBase.initialize();
  await HabitDataBase.saveFirstLaunchDate();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    Future<void> checkTokenAndUser()async{
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth-token');
      String? userJson = preferences.getString('user');
      if(token!=null && userJson!=null){
        ref.read(userProvider.notifier).setUser(userJson);
      }
      else{
        ref.read(userProvider.notifier).signOut();
      }
    }
    return  MaterialApp(
      themeMode: themeMode,
      darkTheme: darkMode,
      theme: lightMode,
      home: FutureBuilder(
          future: checkTokenAndUser(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            final user = ref.watch(userProvider);
            return user!=null ? const MainScreen() :const OnBoardingScreen();
          }
      ),
    );
  }
}
