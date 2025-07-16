
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/roadmap_controller.dart';
import 'package:learnmate/provider/roadmap_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/views/screens/widgets/roadmap_widget.dart';
import 'package:lottie/lottie.dart';

class RoadmapScreen extends ConsumerStatefulWidget {
  const RoadmapScreen({super.key});

  @override
  ConsumerState<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends ConsumerState<RoadmapScreen> {

  TextEditingController goalController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  RoadMapController roadMapController = RoadMapController();

  String? timelimit;
  bool isLoading = false;
  Future<void> getRoadMap()async{
    final userId = ref.read(userProvider)!.id;
    ref.read(roadmapProvider.notifier).getRoadMap(userId: userId);
  }

  final List<String> timeList = [
    '1 Months',
    '2 Months',
    '3 Months',
    '4 Months',
    '5 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    getRoadMap();
  }
  @override
  Widget build(BuildContext context) {
    final roadmap = ref.watch(roadmapProvider);
    final user = ref.read(userProvider);
    return isLoading ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animation/Robot-Bot 3D.json',
            height: 300,
            width: 300,
          ),
          SizedBox(height: 20,),
          Text(
            "RoadMap Is Generating, Please Wait!",
            style: GoogleFonts.montserrat(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 1.7,
              height: 1.5
            ),
            textAlign: TextAlign.center,
          )
        ],
      )
    ) : DraggableHome(
      appBarColor: Colors.lightBlueAccent,
        title: Text("RoadMap",style: GoogleFonts.montserrat(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 1.7,
          height: 1.5
        ),),
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
          child: Center(
            child: Lottie.asset(
              'assets/animation/man_and_robot.json',
              height: 600,
              width: 400,
            ),
          ),
        ),
        body: [
           roadmap.isEmpty
               ?Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Generate Personalized RoadMap\nAnd Become Unstoppable!",
                  style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 1.7,
                      height: 1.5
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter Your Goal",style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 1.7,
                        height: 1.5
                    ),),
                    SizedBox(height: 8,),
                    TextField(
                      controller: goalController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Goal",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text("Enter Your Problem You're Facing",style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 1.7,
                        height: 1.5
                    ),),
                    SizedBox(height: 8,),
                    TextField(
                      controller: problemController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Problem",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text("What is the timeframe for completing your goal?",style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 1.7,
                        height: 1.5
                    ),),
                    SizedBox(height: 8,),
                    CustomDropdown<String>(
                        hintText: 'Select Duration',
                        decoration: CustomDropdownDecoration(
                          expandedFillColor: Theme.of(context).colorScheme.primary,
                          closedFillColor: Theme.of(context).colorScheme.primary,
                          hintStyle: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 1.7,
                            height: 1.5
                          )
                        ),
                        items: timeList,
                        onChanged: (value){
                          timelimit = value;
                        },
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlueAccent.shade100,
                    gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent.shade100,
                          Colors.blue.shade700
                          ]
                    )
                  ),
                  child: TextButton(
                    child: Text(
                      "Generate RoadMap",
                      style: GoogleFonts.grapeNuts(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.7,
                        height: 2
                      ),
                    ),
                    onPressed: ()async {
                      setState(() {
                        isLoading = true;
                      });
                      await roadMapController.getRoadMap(
                          goal: goalController.text,
                          timelimit: timelimit.toString(),
                          problem: problemController.text,
                          userId: user!.id,
                          ref: ref,
                        context: context
                      ).whenComplete(()async{
                        getRoadMap();
                        isLoading = false;
                      });
                    },
                  ),
                ),
              )
            ],
          ) :
               RoadmapWidget(roadMap: roadmap.first),
          roadmap.isNotEmpty ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Not Satisfied With This RoadMap? Delete This RoadMap And Generate New RoadMap!",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent.shade700,
                letterSpacing: 1.7,
                height: 1.5
              ),
            ),
          ) : SizedBox(),
          roadmap.isNotEmpty ? TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            ),
              onPressed: ()async{
              await roadMapController.deleteRoadMap(ref, user!.id, context);
              },
              child: Text(
                "Delete RoadMap",
                style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
              )
          ) : SizedBox()
        ],
    );
  }
}
