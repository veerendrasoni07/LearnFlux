import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/subject_controller.dart';
import 'package:learnmate/models/chapters.dart';
import 'package:learnmate/provider/subject_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/views/screens/details/notes/widgets/chapter_screen.dart';
import 'package:learnmate/views/screens/details/notes/widgets/subject_widget.dart';

class NotesPdfScreen extends ConsumerStatefulWidget {
  final String noteType;
  const NotesPdfScreen({super.key,required this.noteType});

  @override
  ConsumerState<NotesPdfScreen> createState() => _NotesPdfScreenState();
}

class _NotesPdfScreenState extends ConsumerState<NotesPdfScreen> {




  Future<void> fetchAllSubjects ()async{
    final SubjectController subjectController = SubjectController() ;
    final studentClass = ref.read(userProvider)!.studentClass;
    await subjectController.fetchAllSubjects(studentClass: studentClass,noteType: widget.noteType ,ref: ref, context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllSubjects();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Notes",style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          letterSpacing: 1.8,
          color: Theme.of(context).colorScheme.onSurface
        ),),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select Subject You Want To Study :",style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 1.8,
                color: Theme.of(context).colorScheme.tertiary
              ),),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
                itemBuilder: (context,index){
                  final subject = subjects[index];
                  final List<Chapters> chapters = subject.chapters;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ChapterScreen(chapters: chapters,))),
                        child: SubjectWidget(
                            title: subject.subjectName,
                            icon: Icons.ac_unit_rounded
                        )
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
