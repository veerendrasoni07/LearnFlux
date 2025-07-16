import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:learnmate/provider/roadmap_provider.dart';
import 'package:learnmate/service/manage_http_request.dart';

import '../global_variables.dart';
class RoadMapController{

  Future<void> getRoadMap(
      {
        required String goal,
        required String timelimit,
        required String problem,
        required String userId,
        required WidgetRef ref,
        required context
      })async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/roadmap/$userId'),
        body: jsonEncode({
          'goal':goal,
          'timelimit':timelimit,
          'problem':problem,
          'userId':userId
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      manageHttpRequest(response: response, context: context, onSuccess: (){
          showSnackBar(context, 'RoadMap Generated Successfully', 'RoadMap Generated Successfully', ContentType.success);
      });
    }catch(e){
      throw Exception(e);
    }
  }

  // Future<List<RoadMap>> fetchAllRoadMap(WidgetRef ref,String userId)async{
  //   try{
  //     http.Response response = await http.get(Uri.parse('$uri/api/roadmaps/$userId'),headers: <String,String>{
  //       'Content-Type':'application/json; charset=UTF-8'
  //     });
  //     if(response.statusCode == 200){
  //       List<dynamic> data = jsonDecode(response.body);
  //       List<RoadMap> roadmaps = data.map((roadmap)=>RoadMap.fromJson(roadmap)).toList();
  //       ref.read(roadmapProvider.notifier).addRoadMap(roadmaps);
  //       return roadmaps;
  //     }
  //     else{
  //       throw Exception("Error fetching roadmap");
  //     }
  //   }catch(E){
  //     throw Exception(E);
  //   }
  // }
  
  Future<void> deleteRoadMap(WidgetRef ref,String userId,context)async{
    try{
      http.Response response = await http.delete(
          Uri.parse('$uri/api/delete/roadmap/$userId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      manageHttpRequest(
          response: response,
          context: context, 
          onSuccess: (){
            ref.read(roadmapProvider.notifier).clearRoadMap();
            showSnackBar(context, 'RoadMap Deleted Successfully', 'RoadMap Deleted Successfully', ContentType.success);
          }
      );
    }catch(e){
      showSnackBar(context, 'Error Deleting RoadMap', 'Error Deleting RoadMap', ContentType.failure);
      throw Exception(e);
    }
  }
  
}