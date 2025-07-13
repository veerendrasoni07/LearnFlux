import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/auth_controller.dart';
import 'package:learnmate/provider/theme_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/views/ai_chat_screen.dart';
import 'package:learnmate/views/goal_tracker/views/habit_home_page.dart';
import 'package:learnmate/views/screens/nav_screen/roadmap_screen.dart';
import 'package:learnmate/views/screens/nav_screen/notes_pdf_screen.dart';
import 'package:learnmate/views/screens/nav_screen/study_material_screen.dart';
import 'package:learnmate/views/screens/widgets/home_container_widget.dart';
import 'package:learnmate/views/screens/widgets/info_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  bool _shownDialog = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final user = ref.watch(userProvider);

    if(!_shownDialog && user!=null && user.studentClass.isEmpty){
      _shownDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_){
        showUpdateDialog();
      });

    }

  }

  void showUpdateDialog(){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context)=>
            AlertDialog(
              content: InfoScreen(),
    ));
  }

  
  @override
  Widget build(BuildContext context) {

    final userData = ref.read(userProvider);
    final user = ref.watch(userProvider);
    final theme = ref.watch(themeProvider.notifier);
    print(userData!.studentClass);
    return DraggableHome(
      fullyStretchable: true,
      appBarColor: Colors.blueAccent,
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ListTile(
                  title: Text('Dark-Mode',style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.8,
                    color: Theme.of(context).colorScheme.onSurface
                  ),),

                  trailing: CupertinoSwitch(
                      value: theme.isDarkMode,
                      onChanged: (value){
                        theme.toggleTheme();
                      }
                  ),
                ),
              ),
            ],
          )
        ),
        title: Text("LearnMate-AI",style: GoogleFonts.montserrat(fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold),),
        headerWidget: Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent.shade100,
                  Colors.blue.shade700
                ]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/Learnmate_ai_logo.jpg',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        body: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hey ${userData.fullname}!\nWelcome to LearnMate!",
              style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                letterSpacing: 1.7,
                height: 1.5
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>StudyMaterialScreen()
                            )
                        );
                      },
                        child: HomeContainerWidget(
                            title: 'Notes',
                            icon: Icons.upload
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>HabitHomePage())),
                        child: HomeContainerWidget(
                            title: 'New Goal',
                            icon: Icons.add
                        )
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)=>AiChatScreen()
                            )
                        );
                      },
                        child: HomeContainerWidget(
                            title: 'AI Chat',
                            icon: Icons.mark_chat_unread
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RoadmapScreen()));
                      },
                        child: HomeContainerWidget(
                            title: 'View RoadMap',
                            icon: Icons.location_on_rounded
                        )
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: ()async{
                  await AuthController().signOut(context: context, ref: ref);
                },
                child: ListTile(
                  title: Text("Logout",style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 2.5
                  ),),
                  trailing: Icon(
                    Icons.logout,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
            ],
          )
        ]
    );
  }
}
