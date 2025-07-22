import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:learnmate/global_variables.dart';
class ScrapePdfController {


  Future<List<String>> getScrapePdfs({
    required String studentClass,
    required String subject,
    required String chapter
}) async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/fetch-pdfs?studentClass=$studentClass&subject=$subject&chapter=$chapter'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      print(response.body);

      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        List<String> links = data.map((e)=>e.toString()).toList();
        return links;
      }
      else{
        print(response.statusCode);
        throw Exception("Failed to load Links ");

      }

    }catch(e){
      print(e.toString());
      throw Exception("Error Occurred while fetching links : $e");

    }
  }









}