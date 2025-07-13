import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/views/ai_chat_screen.dart';
import 'package:learnmate/views/screens/nav_screen/home_screen.dart';
import 'package:learnmate/views/screens/nav_screen/profile_screen.dart';
import 'package:learnmate/views/screens/nav_screen/roadmap_screen.dart';
import 'package:learnmate/views/screens/nav_screen/notes_pdf_screen.dart';
import 'package:learnmate/views/screens/nav_screen/study_material_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    AiChatScreen(),
    RoadmapScreen(),
    StudyMaterialScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 6,
        currentIndex: _selectedIndex,
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        notchStyle: NotchStyle.circle,
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selectedColor: Color(0xFFB266FF),
            unSelectedColor: Colors.grey,
          ),
          BottomBarItem(
            icon: const Icon(Icons.rocket_launch_outlined),
            title: const Text('AI Chat'),
            selectedColor: Color(0xFFB266FF),
            unSelectedColor: Colors.grey,
          ),
          BottomBarItem(
            icon: const Icon(Icons.library_books_outlined),
            title: const Text('RoadMap'),
            selectedColor: Color(0xFFB266FF),
            unSelectedColor: Colors.grey,
          ),
          BottomBarItem(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            title: const Text('Summarize'),
            selectedColor: Color(0xFFB266FF),
            unSelectedColor: Colors.grey,
          ),
          BottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            selectedColor: Color(0xFFB266FF),
            unSelectedColor: Colors.grey,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
