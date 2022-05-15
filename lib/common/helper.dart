library Helper;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/config.dart';

class Helper {
  static String uuid() {
    return new DateTime.now().millisecondsSinceEpoch.toString();
  }

  static void showErrorToast({msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showSuccessToast({msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Image getImageByBase64orHttp(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl);
    } else {
      var bytesImage = const Base64Decoder().convert(imageUrl);

      return Image.memory(bytesImage);
    }
  }

  static Image getPetImage(int? id) {
    return Image.network(Config.apiServer + "/pets/image/${id}");
  }

  static Future<String> imageToBase64(XFile file) async{
    List<int> imageBytes = await file.readAsBytes();     
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}