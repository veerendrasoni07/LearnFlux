import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/global_variables.dart';
import 'package:learnmate/models/chat_message.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends StateNotifier<List<ChatMessages>>{
  ChatProvider():super([]);

  Future<void> loadChatHistory(String sessionId)async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/history/$sessionId'),
          headers: <String,String>{
            'Content-Type':'application/json'
          }
      );

      if(response.statusCode == 200){
        final decodedData = jsonDecode(response.body);
        final List<dynamic> data = decodedData['history'];

        List<ChatMessages> messages = data.map((item)=>ChatMessages.fromJson(item)).toList();
        state = messages;
      }
      else{
        print("Error occurred during chat history loading");
      }

    }catch(e){
      print('Error occurred bos : $e');
    }
  }


 // reset the chat history when a new session is created.
  void clearState(){
    state = [];
  }

  void addMessage(ChatMessages messages){
    state = [...state,messages];
  }




}

final chatProvider = StateNotifierProvider<ChatProvider,List<ChatMessages>>((ref)=>ChatProvider());