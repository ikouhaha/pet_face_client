import 'package:formz/formz.dart';
import 'package:flutter/material.dart';

enum ConfirmedPasswordValidationError {
  empty,
  mismatch,
}

class ConfirmPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String? password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmPassword.dirty({@required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmedPasswordValidationError.empty;
    }
    return password == value ? null : ConfirmedPasswordValidationError.mismatch;
  }

  //valid
}


extension Explanation on ConfirmedPasswordValidationError {
  String? get name {
    switch (this) {
      case ConfirmedPasswordValidationError.empty:
        return "Please fill the confirm password field";
      case ConfirmedPasswordValidationError.mismatch:
        return 'passwords must match';
      default:
        return null;
    }
  }
}

