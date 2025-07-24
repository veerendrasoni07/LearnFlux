import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:learnmate/global_variables.dart';
class SessionProvider extends StateNotifier<List<Map<String,dynamic>>>{
  SessionProvider():super([]);


  Future<void> loadSessions(String userId)async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/sessions/$userId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        state = List<Map<String,dynamic>>.from(data);
      }
      else{
        throw Exception("Unable to fetch sessions");
      }
    }catch(e){
      throw Exception("Error occurred : $e");
    }
  }

  void deleteSession(String sessionId){
    state = state.where((s)=> s['sessionId'] != sessionId).toList();
  }

  Future<void> changeChatName(String id,String newChatName)async{
    try{
      http.Response response = await http.put(
          Uri.parse('$uri/api/update-chat-name?sessionId=$id&newName=$newChatName'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final updatedSession = state.map((session){
          if(session['_id']==id){
            return {
              ...session,
              'title':newChatName
            };
          }
          return session;
        }).toList();
        state = updatedSession;
      }
      else{
        throw Exception("Error occurred while updating chat name");
      }

    }
    catch(e){
      throw Exception("Error occurred : $e");
    }
  }



}

final sessionProvider = StateNotifierProvider<SessionProvider,List<Map<String,dynamic>>>((ref)=>SessionProvider());