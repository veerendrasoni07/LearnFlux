import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/models/chapters.dart';
import 'package:learnmate/views/screens/details/notes/widgets/chapter_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ChapterScreen extends ConsumerStatefulWidget {
  final List<Chapters> chapters;
  const ChapterScreen({super.key,required this.chapters});

  @override
  ConsumerState<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends ConsumerState<ChapterScreen> {


  final GlobalKey<SfPdfViewerState> _pdfKey = GlobalKey<SfPdfViewerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Chapters",style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          letterSpacing: 1.9,
          color: Theme.of(context).colorScheme.onSurface
        ),) ,
      ) ,
      body:GridView.builder(
            itemCount: widget.chapters.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context,index){
                final chapter = widget.chapters[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>
                                  Scaffold(
                                    backgroundColor: Theme.of(context).colorScheme.background,
                                    appBar: AppBar(),
                                    body: SfPdfViewer.network(
                                      canShowTextSelectionMenu: true,
                                      canShowPaginationDialog: true,
                                      canShowPageLoadingIndicator: true,
                                      canShowScrollHead: true,
                                      chapter.pdf,
                                      key: _pdfKey,
                                    ),
                                  )
                          )
                      );
                    },
                    child: ChapterWidget(
                        title: chapter.chapter,
                        icon: Icons.topic_outlined
                    ),
                  ),
                );
              }
          )

    );
  }
}
