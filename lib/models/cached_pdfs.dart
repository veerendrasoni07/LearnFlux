// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CachedPdfs {
  final List<String> links;
  CachedPdfs({required this.links});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'links': links,
    };
  }

  factory CachedPdfs.fromMap(Map<String, dynamic> map) {
    return CachedPdfs(
      links: List<String>.from((map['links'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CachedPdfs.fromJson(String source) => CachedPdfs.fromMap(json.decode(source) as Map<String, dynamic>);
}
