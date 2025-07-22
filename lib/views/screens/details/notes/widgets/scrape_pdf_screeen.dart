import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/controller/scrapepdf_controller.dart';
import 'package:learnmate/views/screens/details/notes/widgets/chapter_widget.dart';
import 'package:learnmate/views/screens/widgets/pdf_view_screen.dart';

class ScrapePdfScreeen extends ConsumerStatefulWidget {
  const ScrapePdfScreeen({super.key});

  @override
  ConsumerState<ScrapePdfScreeen> createState() => _ScrapePdfScreeenState();
}

class _ScrapePdfScreeenState extends ConsumerState<ScrapePdfScreeen> {
  TextEditingController classController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController chapterController = TextEditingController();
  final ScrapePdfController scrapePdfController = ScrapePdfController();
  Future<List<String>>? futureLinkList;

  void fetchPdf(){
    setState(() {
      futureLinkList = scrapePdfController.getScrapePdfs(
          studentClass: classController.text,
          subject: subjectController.text,
          chapter: chapterController.text
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Scrape Pdf"),
      ),
      body: futureLinkList != null ? FutureBuilder(
          future: futureLinkList,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasError){
              return Center(child: Text("Error Occurred : ${snapshot.error}"),);
            }
            else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No data is present"),);
            }
            else{
              final links = snapshot.data;
              return ListView.builder(
                itemCount: links!.length,
                  itemBuilder: (context,index){
                  final link = links[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewScreen(link: link)));
                        },
                          child: ChapterWidget(
                              title:chapterController.text ,
                              icon: Icons.picture_as_pdf
                          )
                      ),
                    );
                  }
              );
            }
          }
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: classController,
              decoration: InputDecoration(
                hintText: "Enter Your Class",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                prefixIcon: Icon(Icons.school),
                suffixIcon: IconButton(
                  onPressed: (){
                    classController.clear();
                  },
                  icon: Icon(Icons.clear),
              ),)
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: "Enter Subject Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                prefixIcon: Icon(Icons.drive_file_rename_outline_sharp),
                suffixIcon: IconButton(
                  onPressed: (){
                    subjectController.clear();
                  },
                  icon: Icon(Icons.clear),
              ),)
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: chapterController,
              decoration: InputDecoration(
                hintText: "Enter Chapter Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                prefixIcon: Icon(Icons.book),
                suffixIcon: IconButton(
                  onPressed: (){
                    chapterController.clear();
                  },
                  icon: Icon(Icons.clear),
              ),)
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.greenAccent,
            ),
              onPressed: fetchPdf,
              child: Text("Get Pdf")
          )
        ],
      ),
    );
  }
}
