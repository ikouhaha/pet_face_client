import 'dart:ffi';

import 'package:flutter/material.dart';

class Validations {
  static String? validateEmail(String? value) {
     final RegExp _regex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
     if (value == null || value.isEmpty) {
      
      return "Please fill the email field";
    }


    if (!_regex.hasMatch(value)) {
      
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validateName(String? value) {
      final RegExp _regex = RegExp(
    r'^(?=.*[a-z])[A-Za-z ]{2,}$',
  );
     if (value == null || value.isEmpty) {
       
      return "Please fill the name field";
    }

    if (!_regex.hasMatch(value)) {
      
      return 'Please enter a valid name';
    }

    return null;
  }

  static String? validateText(String? value) {
     
     if (value == null || value.isEmpty) {
       
      return "Please fill the field";
    }

    return null;
  }

   static String? validateInt(Int? value) {
     
     if (value == null) {
       
      return "Please fill the field";
    }

    return null;
  }

   static String? validatePassword(String? value) {
     final _regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
     if (value == null || value.isEmpty) {       
      return "Please fill the password field";
    }


    if (!_regex.hasMatch(value)) {      
      return 'Minimum eight characters, at least one letter and one number';
    }

    return null;
  }

  static String? validateConfirmPassword(String? pwd, String? value) {
     final _regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {      
      return "Please fill the confirm password field";
    }

    if (pwd!=value) {      
      return 'Please match with password';
    }

    return null;
  }
}
