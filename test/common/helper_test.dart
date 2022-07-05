import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/firebase_options.dart';
import 'package:pet_saver_client/models/Breed.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('uuid', () {
    expect(Helper.uuid(), isNotNull);
  });

  test('getTimeAgo', () {
    expect(Helper.getTimeAgo(DateTime.now()), isNotNull);
  });

  test('objectToJson', () {
   Breed breed = Breed();
    breed.id = 1;
    breed.name = "test";

    Map expectResult = {
      "id": 1,
      "name": "test"
    };
      
    expect(Helper.objectToJson(breed), expectResult);
  });

  test('getCurrentDateTimeString', () {
    expect(Helper.getCurrentDateTimeString(), isNotNull);
  });



  test('test timeStampToDatetime', () {
    var timenow = DateTime.now().microsecondsSinceEpoch;
   var test = Helper.timeStampToDatetime(timenow);
   var expectResult =  DateTime.fromMicrosecondsSinceEpoch(timenow);
   
    expect(test, expectResult);
  });

  test('test getImageByBase64orHttp', () {
    var imageUrl = "http://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png";
    var result = Helper.getImageByBase64orHttp(imageUrl);
    expect(result, isNotNull);
  });

  test('test getPetImage', () {
    expect(Helper.getPetImage(36), isNotNull);
  });

}