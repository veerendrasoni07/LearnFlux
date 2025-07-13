import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:learnmate/global_variables.dart';
import 'package:learnmate/models/user.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/service/manage_http_request.dart';
import 'package:learnmate/views/screens/authentication/login_screen.dart';
import 'package:learnmate/views/screens/authentication/on_boarding_screen.dart';
import 'package:learnmate/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthController{
  Future<void> signup({
    required String fullname,
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
})async{
    try {
      User user = User(
          id: '',
          fullname: fullname,
          email: email,
          password: password,
          state: '',
          board: '',
          studentClass: '',
          university: '',
          interest: '',
          city: '',
          address: '',
          token: ''
      );
      http.Response response = await http.post(
          Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      manageHttpRequest(response: response, context: context, onSuccess: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        showSnackBar(context, "SignUp Successfully", "Account is created now you can login with same credential!", ContentType.success);
      });
    }catch (e) {
      showSnackBar(context, "Failed To SignUp", e.toString(), ContentType.failure);
    }

  }

  // login

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref
})async{
    try{

      http.Response response = await http.post(
          Uri.parse('$uri/api/login'),
        body: jsonEncode({
          'email':email,
          'password':password,
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      manageHttpRequest(
          response: response,
          context: context,
          onSuccess: ()async{

            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

            String token = await jsonDecode(response.body)['token'];

            await sharedPreferences.setString('auth-token',token );

            final userJson = jsonEncode(jsonDecode(response.body)['user']);

            ref.read(userProvider.notifier).setUser(userJson);

            await sharedPreferences.setString('user', userJson);



            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainScreen()), (route)=>false);
          }
      );
    }catch(e){
      showSnackBar(context, "Login Failed", e.toString(), ContentType.failure);
    }
  }


  Future<void> signOut({
    required BuildContext context,
    required WidgetRef ref,
})async{

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
              "Are you sure you want to logout?",
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: ()async{
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      await preferences.remove('auth-token');
                      ref.read(userProvider.notifier).signOut();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>OnBoardingScreen()), (route)=>false);
                      showSnackBar(
                          context, 'Logout Successfully',
                          'Logout Successfully, You can login again with the same credentials',
                          ContentType.success
                        );
                    },
                    child: Text("Yes",
                      style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface
                      ),
                    )
                ),
                SizedBox(width: 15,),
                TextButton(onPressed: ()=>Navigator.pop(context), child: Text("No",style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface
                ),))
              ],
            ),
          );
        }
    );

}


// edit profile

  Future<void> updateStudentDetail({
    required String userId,
    required String board,
    required String studentClass,
    required String state,
    required String city,
    required String interest,
    required BuildContext context,
    required WidgetRef ref
})async{
    try{
      http.Response response = await http.put(
          Uri.parse('$uri/api/update/profile/$userId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'board':board,
          'studentClass':studentClass,
          'state':state,
          'city':city,
          'interest':interest
        })
      );

      manageHttpRequest(response: response, context: context, onSuccess: ()async{

        final updatedUser = jsonDecode(response.body);

        SharedPreferences preferences = await SharedPreferences.getInstance();

        final userJson = jsonEncode(updatedUser);

        ref.read(userProvider.notifier).setUser(userJson);

        await preferences.setString('user', userJson);

        Navigator.pop(context);

        WidgetsBinding.instance.addPostFrameCallback((_){
          showSnackBar(context, 'Your Profile Is Updated', 'Now You Can Explore LearnMate!', ContentType.success);
        });

      });


    }catch(e){
      print(e.toString());
      showSnackBar(context, "Error Occurred", e.toString(), ContentType.failure);
    }


  }



  Future<void> editStudentDetail({
    required String userId,
    required String fullname,
    required String board,
    required String studentClass,
    required String state,
    required String city,
    required String interest,
    required BuildContext context,
    required WidgetRef ref
  })async{
    try{
      http.Response response = await http.put(
          Uri.parse('$uri/api/edit/profile/$userId'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: jsonEncode({
            'fullname':fullname,
            'board':board,
            'studentClass':studentClass,
            'state':state,
            'city':city,
            'interest':interest
          })
      );

      manageHttpRequest(response: response, context: context, onSuccess: ()async{

        final updatedUser = jsonDecode(response.body);

        SharedPreferences preferences = await SharedPreferences.getInstance();

        final userJson = jsonEncode(updatedUser);

        ref.read(userProvider.notifier).setUser(userJson);

        await preferences.setString('user', userJson);

        Navigator.pop(context);

        WidgetsBinding.instance.addPostFrameCallback((_){
          showSnackBar(context, 'Your Profile Is Updated', 'Now You Can Explore LearnMate!', ContentType.success);
        });

      });


    }catch(e){
      print(e.toString());
      showSnackBar(context, "Error Occurred", e.toString(), ContentType.failure);
    }
  }
  
  Future<void> changeClass({
    required String userId,
    required String studentClass,
    required WidgetRef ref,
    required context
  })async{
    try{
      http.Response response = await http.put(
          Uri.parse('$uri/api/change-class/$userId'),
        body: jsonEncode({
          'studentClass':studentClass
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      manageHttpRequest(
          response: response,
          context: context,
          onSuccess: ()async{

            final updatedUser = jsonDecode(response.body);

            SharedPreferences preferences = await SharedPreferences.getInstance();

            final userJson = jsonEncode(updatedUser);

            ref.read(userProvider.notifier).setUser(userJson);

            await preferences.setString('user', userJson);

          }
      );
    }catch(e){
      throw Exception(e.toString());
    }
  }

}