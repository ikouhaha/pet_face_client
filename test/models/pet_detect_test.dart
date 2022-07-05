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
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/findSimilarity.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/petDetect.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  String img64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=";
   
  test('test PetDetectResponse',(){
    
    PetDetectResponse obj = PetDetectResponse();
    obj.name = "test";
    obj.cropImgs = [img64];
    obj.labelImg = img64;

    
    expect(obj.name, "test");
    expect(obj.cropImgs, [img64]);
    expect(obj.labelImg, img64);
  
  });

  test('test petDetectResponseFromJson',(){
    var list = petDetectResponseFromJson("[{\"name\":\"test\",\"cropImgs\":[\"$img64\"],\"labelImg\":\"$img64\"}]");
    expect(list, isNotNull);
  
  });


  test('test petDetectResponseToJson',(){
   List<PetDetectResponse> list = [];
    PetDetectResponse obj = PetDetectResponse(name: "test", cropImgs: [img64], labelImg: img64);
    list.add(obj);
    var json = petDetectResponseToJson(list);
    expect(json, isNotNull);

  });

   test('test PetDetectResponse.fromJson',(){
    var json = {
      "name": "test",
      "cropImgs": ["$img64"],
      "labelImg": "$img64"

    };
    
    
    
    PetDetectResponse obj = PetDetectResponse.fromJson(json);

    expect(obj.name, "test");
    expect(obj.cropImgs, [img64]);
    expect(obj.labelImg, img64);

  });
  
  test('test PetDetectResponse.toJson',(){
    var json = {
      "name": "test",
      "cropImgs": ["$img64"],
      "labelImg": "$img64"
    };
    

    PetDetectResponse obj = PetDetectResponse.fromJson(json);
    var result = obj.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
      "name": "test",
      "cropImgs": ["$img64"],
      "labelImg": "$img64"
      };
    
    
    PetDetectResponse obj = PetDetectResponse.fromJson(json);
    obj = obj.copyWith(name: "test2", cropImgs: [img64], labelImg: img64);
    
    expect(obj.name, "test2");
    expect(obj.cropImgs, [img64]);
    expect(obj.labelImg, img64);
    
  });
  

}