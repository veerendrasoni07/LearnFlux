import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chapters {
  final String studentClass;
  final String subject;
  final String chapter;
  final String pdf;
  Chapters({
    required this.studentClass,
    required this.subject,
    required this.chapter,
    required this.pdf,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentClass': studentClass,
      'subject': subject,
      'chapter': chapter,
      'pdf': pdf,
    };
  }

  String toJson() => json.encode(toMap());
  
  factory Chapters.fromJson(Map<String, dynamic> map) {
    return Chapters(
      studentClass: map['studentClass'] as String,
      subject: map['subject'] as String,
      chapter: map['chapter'] as String,
      pdf: map['pdf'] as String,
    );
  }

  


}
