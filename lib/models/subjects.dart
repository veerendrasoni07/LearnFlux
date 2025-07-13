import 'dart:convert';

import 'package:learnmate/models/chapters.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Subject {
  final String subjectName;
  final String studentClass;
  final List<Chapters> chapters;
  Subject({
    required this.subjectName,
    required this.studentClass,
    required this.chapters,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectName': subjectName,
      'studentClass': studentClass,
      'chapters': chapters.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(Map<String, dynamic> map) {
    return Subject(
      subjectName: map['subjectName'] as String,
      studentClass: map['studentClass'] as String,
      chapters: List<Chapters>.from((map['chapters'] as List).map<Chapters>((x) => Chapters.fromJson(x as Map<String,dynamic>),),),
    );
  }

  

}
