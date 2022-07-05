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
import 'package:pet_saver_client/models/notification.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('test notification',(){
    
    Notifications obj = Notifications();
    obj.key = "test";
    obj.type = "cm";
    obj.jsonValue = "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]";
    
    expect(obj.key, "test");
    expect(obj.type, "cm");
    expect(obj.jsonValue, "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]");
  });

  test('test notificationsFromJson',(){
    var list = notificationsFromJson("[{\"key\":\"test\",\"type\":\"cm\",\"jsonValue\":\"[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]\"}]");
    expect(list, isNotNull);
  
  });


  test('test notificationsToJson',(){
   List<Notifications> list = [];
    Notifications obj = Notifications(key: "test", type: "cm", jsonValue: "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]");
    list.add(obj);
    var json = notificationsToJson(list);
    expect(json, isNotNull);

  });

   test('test Notifications.fromJson',(){
    var json = {
      "key": "test",
      "type": "cm",
      "jsonValue": "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]"
    
    };
    
    
    
    Notifications obj = Notifications.fromJson(json);

    expect(obj.key, "test");
    expect(obj.type, "cm");
    expect(obj.jsonValue, "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]");

  });
  
  test('test Notifications.toJson',(){
    var json = {
      "key": "test",
      "type": "cm",
      "jsonValue": "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]"
    
    
    };

    Notifications obj = Notifications.fromJson(json);
    var result = obj.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
      "key": "test",
      "type": "cm",
      "jsonValue": "[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]"
      };
    
    
    Notifications obj = Notifications.fromJson(json);
    obj = obj.copyWith(key: "test2");
    expect(obj.key, "test2");
    
    
  });
  

}