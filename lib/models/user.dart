// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.id,
        this.email,
        this.password,
        this.username,
        this.firstName,
        this.lastName,
        this.role,
        this.companyCode,
        this.avatarUrl,
        this.googleId,
        this.dateRegistered,
        
    });

    int? id;
    String? email;
    String? password;
    String? username;
    String? firstName;
    String? lastName;
    String? role;
    String? companyCode;
    String? avatarUrl;
    String? googleId;
    DateTime? dateRegistered;
    NetworkImage? avatar;

    UserModel copyWith({
        int? id,
        String? email,
        String? password,
        String? username,
        String? firstName,
        String? lastName,
        String? role,
        String? companyCode,
        String? avatarUrl,
        String? googleId,
        DateTime? dateRegistered,
        
    }) => 
        UserModel(
            id: id ?? this.id,
            email: email ?? this.email,
            password: password ?? this.password,
            username: username ?? this.username,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            role: role ?? this.role,
            companyCode: companyCode ?? this.companyCode??"",
            avatarUrl: avatarUrl ?? this.avatarUrl,
            googleId: googleId ?? this.googleId,
            dateRegistered: dateRegistered ?? this.dateRegistered,
            
        );

    

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
        companyCode: json["companyCode"],
        avatarUrl: json["avatarUrl"],
        googleId: json["googleId"],
        dateRegistered: DateTime.parse(json["dateRegistered"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
        "companyCode": companyCode,
        "avatarUrl": avatarUrl,
        "googleId": googleId,
        "dateRegistered": dateRegistered?.toIso8601String(),
    };
}
