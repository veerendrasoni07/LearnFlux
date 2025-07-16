import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/global_variables.dart';
import 'package:learnmate/models/roadmap.dart';
import 'package:http/http.dart' as http;
class RoadMapProvider extends StateNotifier<List<RoadMap>>{
  RoadMapProvider() : super(
    []
  );


  Future<void> getRoadMap({required String userId})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/roadmaps/$userId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        List<RoadMap> roadmaps = data.map((roadmap)=>RoadMap.fromJson(roadmap)).toList();
        state = roadmaps;
      }
      else{
         throw Exception("Unable to fetch roadmaps ");
      }
    }catch(e){
      throw Exception("Failed to load roadmaps : $e");
    }
  }

  void clearRoadMap(){
    state = [];
  }




}
final roadmapProvider = StateNotifierProvider<RoadMapProvider,List<RoadMap>>((ref)=>RoadMapProvider());