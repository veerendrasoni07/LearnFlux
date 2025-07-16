import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:learnmate/global_variables.dart';
import 'package:learnmate/models/chat_message.dart';
import 'package:learnmate/provider/chat_provider.dart';
import 'package:learnmate/provider/session_provider.dart';
import 'package:learnmate/service/manage_http_request.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class AiController{

  Future<String?> createNewSession({required String title,required String userId})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/session'),
        body: jsonEncode({
          'title':title,
          'userId':userId
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['sessionId'];
      }
      else{
        print("Error occurred");
        return null;
      }

    }catch(e){
      print("Error: $e");
      return null;

    }
  }


  Future<String?> getAiResponse({required String question,required String sessionId,required WidgetRef ref,required String userId})async {
    try {
      ref.read(chatProvider.notifier).addMessage(ChatMessages(role: 'user', text: question));
      http.Response response = await http.post(
          Uri.parse('$uri/api/explain'),
          body: jsonEncode({
            'question': question,
            'sessionId':sessionId,
            'userId':userId
          }),
          headers: <String, String>{
            'Content-Type': 'application/json'
          }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ref.read(chatProvider.notifier).addMessage(ChatMessages(role: 'model', text: data['result']));
        return data['result'];
      }
      else {
        print("Error occurred : ${response.statusCode}");
        return null;
      }
    }
    catch (e) {
      print("Error: $e");
      return null;
    }
  }


  
  // delete session 
  Future<void> deleteSession(String sessionId,BuildContext context,WidgetRef ref)async{
    try {
      http.Response response = await http.delete(
          Uri.parse('$uri/api/session/delete/$sessionId'),
        headers: <String, String>{
            'Content-Type': 'application/json'
        }
      );

      if(response.statusCode == 200){
        manageHttpRequest(response: response, context: context, onSuccess: (){
          ref.read(chatProvider.notifier).clearState();
          ref.read(sessionProvider.notifier).deleteSession(sessionId);
          showSnackBar(context, 'Deleted Successfully', 'Chat Session Deleted Successfully', ContentType.success);
          Navigator.pop(context);
        });
      }
      else {
        print('Error deleting session');
        showSnackBar(context, 'Error deleting session', 'Error deleting session', ContentType.warning);
      }
    }
    catch(e){
      showSnackBar(context, 'Error deleting session', 'Error deleting session', ContentType.failure);
      print('Error deleting session : $e');
    }
  }

}