import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/ai_controller.dart';
import 'package:learnmate/provider/chat_provider.dart';
import 'package:learnmate/provider/session_provider.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:markdown_widget/markdown_widget.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController titleController = TextEditingController();
  final AiController aiController = AiController();

  bool isLoading = false;
  String? sessionId;


  Future<void> loadSessions()async{
    final user = ref.read(userProvider);
    ref.read(sessionProvider.notifier).loadSessions(user!.id);
  }


  Future<void> startNewSession(String title,String userId)async{
    try{
      final id = await aiController.createNewSession(title: title,userId: userId);
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
  TextEditingController newChatName = TextEditingController();

  Future<void> updateChatName(String id)async{
    try{
      ref.read(sessionProvider.notifier).changeChatName(id, newChatName.text.trim());
    }
    catch(e){
      print(e);
    }
  }

  Future<void> askAI()async{
    final question = controller.text.trim();
    final user = ref.read(userProvider);
    if(question.isEmpty) return ;
    setState(() {
      isLoading = true;
      controller.clear();
    });
    await aiController.getAiResponse(question: question,sessionId:sessionId.toString(),ref: ref,userId: user!.id);
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
    final messages = ref.watch(chatProvider);
    final user = ref.read(userProvider);
    final sessions = ref.watch(sessionProvider);
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface
        ),
        title: Text("LearnFlux AI",style: GoogleFonts.montserrat(
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
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                              enabled: true,
                              cursorColor: Theme.of(context).colorScheme.onSurface,
                              decoration: InputDecoration(
                                hintText: "Enter a title",
                                enabled: true,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.onSurface
                                ),
                                fillColor:Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.onSurface
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                          ),
                            actions: [
                              TextButton(

                                  onPressed: ()async{
                                    await startNewSession(titleController.text,user!.id);
                                    Navigator.pop(context);
                                    await loadSessions();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.secondary)
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
                  itemCount: sessions.length,
                    itemBuilder: (context,index){
                      final session = sessions[index];
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: ()async{
                                    await updateChatName(session['_id']);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color:Theme.of(context).colorScheme.onSurface,
                                  )
                              ),
                              IconButton(
                                  onPressed: ()async{
                                    await deleteSession(session['sessionId']);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color:Theme.of(context).colorScheme.onSurface,
                                  )
                              ),
                            ],
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
              child: messages.isEmpty ?
              SingleChildScrollView(
                child: Column(
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
                ),
              ) : ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                  itemBuilder: (context,index){
                    final message = messages[index];
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
                        child: MarkdownWidget(
                            data: message.text,
                          shrinkWrap: true,
                          config: MarkdownConfig(
                            configs: [
                              H1Config(
                                  style: GoogleFonts.montserrat(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 2,
                                  )
                              ),
                              H2Config(
                                  style: GoogleFonts.lato(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.7,
                                  )
                              ),
                              H3Config(
                                  style: GoogleFonts.lato(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.7,
                                  )
                              ),
                              H4Config(
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.7,
                                  )
                              ),
                              H5Config(
                                  style: GoogleFonts.lato(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.7,
                                  )
                              ),
                              H6Config(
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: 1.7,
                                  )
                              ),
                            ]
                          ),
                        )
                      ),
                    );
                  }
              )
          ),
          if(isLoading)
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset('assets/animation/Cute bear dancing.json',height: 80,width: 80),
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
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.7
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      decoration: InputDecoration(
                        hintText: "Ask LearnFlux anything...",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600
                        ),
                        fillColor:Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                        filled: true,
                        enabled: true,
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
                        color: Theme.of(context).colorScheme.surface,
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
