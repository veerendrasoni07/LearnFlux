import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/ai_controller.dart';
import 'package:learnmate/provider/chat_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:lottie/lottie.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final AiController aiController = AiController();

  List<Map<String,dynamic>> _sessions =[];
  bool isLoading = false;
  String? sessionId;


  Future<void> loadSessions()async{
    final userId = ref.read(userProvider)!.id;
    final fetchedSession = await aiController.fetchAllSession(userId);
    print(fetchedSession);
    setState(() {
      _sessions = fetchedSession;
    });
  }


  Future<void> startNewSession(String title)async{
    try{
      final id = await aiController.createNewSession(title);
      if(id!=null){
        setState(() {
          sessionId = id;
          ref.read(chatProvider.notifier).clearState();
          titleController.clear();
        });
        ref.read(chatProvider.notifier).loadChatHistory(id);
      }
    }catch(e){
      print('Error occurred : $e');
    }
  }

  Future<void> deleteSession(String sessionId)async{
    try{
      await aiController.deleteSession(sessionId, context, ref);
    }catch(e){
      print('Error occurred : $e');
    }
  }

  Future<void> askAI()async{
    final question = controller.text.trim();
    if(question.isEmpty) return ;
    setState(() {
      isLoading = true;
      controller.clear();
    });
    await aiController.getAiResponse(question: question,sessionId:sessionId!,ref: ref);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSessions();
  }
  @override
  Widget build(BuildContext context) {
    final _message = ref.watch(chatProvider);
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface
        ),
        title: Text("LearnMate AI",style: GoogleFonts.montserrat(
          fontSize: 30,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 1,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(
                      20
                  ),
                ),child: Center(
                  child: Text(
                      "Sessions",
                      style: GoogleFonts.montserrat(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        fontSize: 35,
                        letterSpacing: 3,
                        height: 4
                      )
                  ),
                )
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(
                      20
                  ),
                ),
                child: TextButton.icon(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            title: Text("Start New Chat",style: GoogleFonts.lato(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                              color: Theme.of(context).colorScheme.onSurface
                            ),),
                            content: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: "Enter a title",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                          ),
                            actions: [
                              TextButton(

                                  onPressed: ()async{
                                    await startNewSession(titleController.text);
                                    Navigator.pop(context);
                                    await loadSessions();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
                                  ),
                                  child: Text("Start",style: GoogleFonts.lato(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.7,
                                    color: Theme.of(context).colorScheme.onSurface
                                  ),)
                              )
                            ],
                      ));
                    },
                    icon: Icon(Icons.add,color: Theme.of(context).colorScheme.onSurface,size:30),
                    label: Text("New Chat",style: GoogleFonts.quicksand(color: Theme.of(context).colorScheme.onSurface,fontWeight: FontWeight.bold,fontSize: 20),)
                ),
              ),
          
              Expanded(
                child: ListView.builder(
                  itemCount: _sessions.length,
                    itemBuilder: (context,index){
                      final session = _sessions[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          title: Text(
                            session['title'],
                            style: GoogleFonts.quicksand(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          contentPadding: EdgeInsets.all(10),
                          trailing: IconButton(
                              onPressed: ()async{
                                await deleteSession(session['sessionId']);
                              },
                              icon: Icon(
                                Icons.delete,
                                color:Theme.of(context).colorScheme.onSurface,
                              )
                          ),
                          tileColor:Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20
                            )
                          ),
                          focusColor: Colors.black12,
                          onTap: ()async{
                            setState(() {
                              sessionId = session['sessionId'];
                              isLoading = true;
                            });
                            await ref.read(chatProvider.notifier).loadChatHistory(sessionId!);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: _message.isEmpty ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/ai_powered_marketing_tool.json',
                    height: 300,
                    width: 300
                  ),
                  Text("Let's Start A New Session !",
                    style: GoogleFonts.montserrat(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ) : ListView.builder(
                shrinkWrap: true,
                itemCount: _message.length,
                  itemBuilder: (context,index){
                    final message = _message[index];
                    final isUser = message.role == 'user';
                    return Align(
                      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.text,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    );
                  }
              )
          ),
          if(isLoading)
             Padding(
              padding: EdgeInsets.all(8.0),
              child:Row(
                children: [
                  CircularProgressIndicator(color: Theme.of(context).colorScheme.onSurface,),
                  SizedBox(width: 10,),
                  Text("Loading...",style: GoogleFonts.montserrat(
                      color: Theme.of(context).colorScheme.onSurface
                  ),
                  )
                ],
              )
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Ask LearnMate anything...",
                        hintStyle: GoogleFonts.lato(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface
                        ),
                        fillColor:Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isLoading ? null : askAI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: Icon(
                        Icons.arrow_upward,
                        color: Theme.of(context).colorScheme.background,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
