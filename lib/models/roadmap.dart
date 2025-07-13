// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RoadMap {
  final String id;
  final String goal;
  final String timelimit;
  final String problem;
  final String roadmap;
  final String userId;

  RoadMap({
    required this.id,
    required this.goal,
    required this.timelimit,
    required this.problem,
    required this.roadmap,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'goal': goal,
      'timelimit': timelimit,
      'problem': problem,
      'roadmap': roadmap,
      'userId':userId
    };
  }

  factory RoadMap.fromJson(Map<String, dynamic> map) {
    return RoadMap(
      id: map['_id'] ?? '',
      goal: map['goal'] ?? '',
      timelimit: map['timelimit']  ?? '',
      problem: map['problem']  ?? '',
      roadmap: map['roadmap']  ?? '',
      userId: map['userId']  ?? '',
    );
  }

  String toJson() => json.encode(toMap());

}
