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
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('test Option',(){
    
    Option obj = Option();
    obj.name = "test";
    obj.value = "test";
    
    expect(obj.name, "test");
    expect(obj.value, "test");
  
  });

  test('test optionsFromJson',(){
    var list = optionsFromJson("[{\"name\":\"test\",\"value\":\"test\"}]");
    expect(list, isNotNull);
  
  });


  test('test optionsToJson',(){
   List<Option> list = [];
    Option obj = Option(name: "test", value: "test");
    list.add(obj);
    var json = optionsToJson(list);
    expect(json, isNotNull);

  });

   test('test Option.fromJson',(){
    var json = {
      "name": "test",
      "value": "test"
    
    };
    
    
    
    Option obj = Option.fromJson(json);

    expect(obj.name, "test");
    expect(obj.value, "test");

  });
  
  test('test Option.toJson',(){
    var json = {
      "name": "test",
      "value": "test"
    };

    Option obj = Option.fromJson(json);
    var result = obj.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
      "name": "test",
      "value": "test"
      };
    
    
    Option obj = Option.fromJson(json);
    obj = obj.copyWith(name: "test2", value: "test2");
    expect(obj.name, "test2");
    expect(obj.value, "test2");
  });
  

}