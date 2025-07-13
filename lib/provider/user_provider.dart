import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learnmate/models/user.dart';

class UserProvider extends StateNotifier<User?>{
  UserProvider():super(null);

  User? get user =>state;

  void setUser(String userJson){
    final user = User.fromJson(userJson);
    state = user;
  }

  void signOut(){
    state = null;
  }


}

final userProvider = StateNotifierProvider<UserProvider,User?>((ref)=>UserProvider());
