import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:learnmate/global_variables.dart';
import 'package:learnmate/models/subjects.dart';
import 'package:learnmate/provider/subject_provider.dart';
class SubjectController{



  Future<List<Subject>> fetchAllSubjects(
  {
    required String studentClass,
    required String noteType,
    required WidgetRef ref,
    required context
}) async{

    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/notes/?studentClass=$studentClass&noteType=$noteType'),
        headers: <String,String>{
            'Content-Type':'application/json;'
        }
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Subject> subjects = data.map((subject)=>Subject.fromJson(subject)).toList();
        ref.read(subjectProvider.notifier).setSubject(subjects);
        return subjects;
      }
      else{
        throw Exception('Failed to fetch subjects');
      }


    }catch(e){
      throw Exception('Failed to fetch subjects');
    }

  }


}