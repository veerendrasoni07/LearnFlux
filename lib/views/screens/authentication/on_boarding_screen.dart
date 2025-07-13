import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/views/screens/authentication/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB266FF), // Light purple
                Color(0xFF66CCFF), // Light blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.menu_book_outlined, size: 40, color: Colors.purple),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'BrainMate',
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.7
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your AI Learning Companion',
                      style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 1.7,
                          height: 1.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/AI_teaching.jpg',// Replace with your image
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Learn Smarter, Not Harder',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.7
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Let AI create personalized learning paths, summarize content, and guide you to success',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.black87,
                          letterSpacing: 1.7,
                          height: 1.5,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Get Started',style: GoogleFonts.grandHotel(
                        fontSize: 30,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold
                      ),)
                    ),
                  )
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
