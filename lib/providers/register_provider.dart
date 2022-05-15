import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';





import 'package:pet_saver_client/formz/CImage.dart';
import 'package:pet_saver_client/formz/name.dart';

// ignore: non_constant_identifier_names
final ChangeNotifierProvider<RegisterNotifier> RegisterProvider =
    ChangeNotifierProvider((_) => RegisterNotifier());

class RegisterNotifier extends ChangeNotifier {
  Username _petName = Username.pure();
   CImage _image = CImage.pure();
 
 
  CImage get image => this._image;

  Image getImg() {
    String path = _image.value!.path;
    return kIsWeb ? Image.network(path) : Image.file(File(path));
  }

   XFile getFile()  {
     return _image.value!;
  }


  FormzStatus _status = FormzStatus.pure;

  Username get petName => this._petName;
  FormzStatus get status => _status;

  void setPetName(String value){
    this._petName = Username.dirty(value);
     _status = Formz.validate([_petName,_image]);
    notifyListeners();
  }

  void setImage(XFile image){
    this._image = CImage.dirty(image);
     _status = Formz.validate([_petName,_image]);
    notifyListeners();
  }
}
