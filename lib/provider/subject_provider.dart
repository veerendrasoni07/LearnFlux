import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/models/subjects.dart';

class SubjectProvider extends StateNotifier<List<Subject>>{
  SubjectProvider():super([]);


  void setSubject (List<Subject> subjects){
    state = subjects;
  }



}


final subjectProvider = StateNotifierProvider<SubjectProvider,List<Subject>>((ref)=>SubjectProvider());