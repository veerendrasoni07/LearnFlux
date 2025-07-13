import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/models/roadmap.dart';

class RoadMapProvider extends StateNotifier<List<RoadMap>>{
  RoadMapProvider() : super(
    []
  );


  void addRoadMap(List<RoadMap> roadmap){
    state = roadmap;
  }

  void clearRoadMap(){
    state = [];
  }




}
final roadmapProvider = StateNotifierProvider<RoadMapProvider,List<RoadMap>>((ref)=>RoadMapProvider());