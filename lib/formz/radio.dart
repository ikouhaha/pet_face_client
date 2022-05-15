
import 'package:formz/formz.dart';

enum TextError { empty, invalid }

class CRadioField extends FormzInput<String, TextError> {
  bool? isRequired ;

  CRadioField.pure({this.isRequired = true , value = ''}) : super.pure(value);
  CRadioField.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^(?=.*[a-z])[A-Za-z ]{2,}$',
  );

  @override
  TextError? validator(String value) {
    if(isRequired!=true){
      return null;
    }
    if (value.isEmpty) {
      return TextError.empty;
    }
    return null;
  }
}

extension Explanation on TextError {
  String? get name {
    switch(this) {
      case TextError.empty:
        return "Please fill the field";
      case TextError.invalid:
        return "This is not a valid value";
      default:
        return null;
    }
  }
}