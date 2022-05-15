import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

enum ImageValidationError { empty,invalid }

class CImage extends FormzInput<XFile?, ImageValidationError> {
   const CImage.pure() : super.pure(null);
   const CImage.dirty(XFile value) : super.dirty(value);

  @override
  ImageValidationError? validator(XFile? value) {   
    if(value==null){
      return ImageValidationError.empty;
    }   
    return null;
  }
}

extension Explanation on ImageValidationError {
  String? get name {
    switch(this) {
      case ImageValidationError.empty:
        return "The Image cant not be empty";
      default:
        return null;
    }
  }
}