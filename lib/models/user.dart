// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String fullname;
  final String email;
  final String password;
  final String state;
  final String board;
  final String studentClass;
  final String university;
  final String interest;
  final String city;
  final String address;
  final String token;
  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.password,
    required this.state,
    required this.board,
    required this.studentClass,
    required this.university,
    required this.interest,
    required this.city,
    required this.address,
    required this.token,

  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'email': email,
      'password': password,
      'state': state,
      'board': board,
      'studentClass': studentClass,
      'university': university,
      'interest': interest,
      'city': city,
      'address': address,
      'token': token
    };
  }

  String toJson() => json.encode(toMap());
  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      state: map['state'] ?? '',
      board: map['board'] ?? '',
      studentClass: map['studentClass'] ?? '',
      university: map['university'] ?? '',
      interest: map['interest'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      token: map['token'] ?? '',
    );
  }

  

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
