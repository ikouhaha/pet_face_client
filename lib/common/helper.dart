// ignore_for_file: library_names

library Helper;

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/models/storage.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class Helper {
  static String uuid() {
    // ignore: unnecessary_new
    return new DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String getTimeAgo(DateTime? dateTime) {
    if(dateTime==null){
      return "";
    }
    //final fifteenAgo = dateTime!.subtract(new Duration(minutes: 15));

    return (timeago.format(dateTime)); // 15 minutes ago
  }
  
  static String getCurrentDateTimeString(){
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
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

  static Future<void>  refreshToken() async{
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    if(token!=null){
       SharedPreferencesService.save("token", token);
    }
   
  }


  static Image getPetImage(int? id) {
    return Image.network(Config.apiServer + "/posts/image/${id}");
  }

  static Future<String> imageToBase64(XFile file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
