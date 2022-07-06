// ignore_for_file: library_names

library Helper;

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
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
  
  static dynamic objectToJson(Object object) {
    return json.decode(json.encode(object));
  }

  static String getCurrentDateTimeString(){
    return DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now());
  }


  static DateTime timeStampToDatetime(int timestamp){
    return DateTime.fromMicrosecondsSinceEpoch(timestamp);
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
