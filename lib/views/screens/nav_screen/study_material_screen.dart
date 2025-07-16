import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/auth_controller.dart';
import 'package:learnmate/views/screens/nav_screen/notes_pdf_screen.dart';

import '../../../provider/user_provider.dart';
class StudyMaterialScreen extends ConsumerStatefulWidget {
  const StudyMaterialScreen({super.key});

  @override
  ConsumerState<StudyMaterialScreen> createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends ConsumerState<StudyMaterialScreen> {
  List<String> classes = [
    'Class 10th',
    'Class 11th',
    'Class 12th'
  ];
  String? _selectedClass;
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    return Scaffold(
      appBar : AppBar(
        title : Text("Study Material")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomDropdown<String>(
            onChanged: (value)async{
              _selectedClass = value!;
              setState(() {
                AuthController().changeClass(
                    userId: user.id,
                    studentClass: _selectedClass.toString(),
                    ref: ref,context: context
                );
              });

            },
            initialItem: user!.studentClass,
            items: classes,
            decoration: CustomDropdownDecoration(
                closedFillColor: Theme.of(context).colorScheme.surface,
                expandedFillColor: Theme.of(context).colorScheme.surface,
                hintStyle: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 1.7,
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> NotesPdfScreen(noteType: "Detailed Notes")
                        )
                    );
                  },
                  child: Container(
                    height:50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("Detailed Notes",style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: 1.7,
                    ),)),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> NotesPdfScreen(noteType: "Short Notes")
                        )
                    );
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                        child: Text(
                          "Short Notes",
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 1.7,
                          ),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NotesPdfScreen(noteType: 'Important Questions')));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                        child: Text(
                            "Important Questions",
                          style: GoogleFonts.lato(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 1.7,
                          ),
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
