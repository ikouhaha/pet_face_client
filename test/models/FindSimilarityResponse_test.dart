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
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('test FindSimilarityResponse',(){
    
    FindSimilarityResponse similarityResponse = FindSimilarityResponse();
    similarityResponse.distance = 1;
    similarityResponse.filename = "test.jpg";
    
    expect(similarityResponse.distance, 1);
    expect(similarityResponse.filename, "test.jpg");

  });

  test('test findSimilarityResponseFromJson',(){
    var list = findSimilarityResponseFromJson("[{\"distance\":1,\"filename\":\"test.jpg\"}]");
    expect(list, isNotNull);
  
  });


  test('test findSimilarityResponseToJson',(){
   List<FindSimilarityResponse> list = [];
    FindSimilarityResponse obj = FindSimilarityResponse(distance: 1, filename: "test.jpg");
    list.add(obj);
    var json = findSimilarityResponseToJson(list);
    expect(json, isNotNull);

  });

   test('test FindSimilarityResponse.fromJson',(){
    var json = {
      "distance": 1,
      "filename": "test.jpg"
    };
    
    
    
    FindSimilarityResponse obj = FindSimilarityResponse.fromJson(json);

    expect(obj.distance, 1);
    expect(obj.filename, "test.jpg");

  });
  
  test('test FindSimilarityResponse.toJson',(){
    var json = {
      "distance": 1,
      "filename": "test.jpg"
    };

    FindSimilarityResponse obj = FindSimilarityResponse.fromJson(json);
    var result = obj.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
        "distance": 1,
        "filename": "test.jpg"
      };
    
    
    FindSimilarityResponse obj = FindSimilarityResponse.fromJson(json);
    obj = obj.copyWith(distance: 2, filename: "test2.jpg");
    expect(obj.distance, 2);
    expect(obj.filename, "test2.jpg");
    
    
  });
  

}