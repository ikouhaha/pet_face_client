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

   
  test('test breed',(){
    Breed breed = Breed();
    breed.id = 1;
    breed.name = "test";
 
    expect(breed.id, 1);
    expect(breed.name, "test");
   
  });

  test('test BreedFromJson',(){
    var list = BreedFromJson("[{\"id\":1,\"name\":\"test\"}]");
    expect(list, isNotNull);
   
  });


  test('test BreedToJson',(){
   List<Breed> breeds = [];
    Breed breed = Breed(id: 1, name: "test");
    breed.id = 1;
    breed.name = "test";
    breeds.add(breed);
    var json = BreedToJson(breeds);
    expect(json, isNotNull);

  });

   test('test Breed.fromJson',(){
    var json = {
      "id": 1,
      "name": "test"
    };
    
    Breed breed = Breed.fromJson(json);
    expect(breed.id, 1);
    expect(breed.name, "test");
  });
  
  test('test Breed.toJson',(){
    var json = {
      "id": 1,
      "name": "test"
    };
    
    Breed breed = Breed.fromJson(json);
    var result = breed.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
      "id": 1,
      "name": "test"
    };
    
    Breed breed = Breed.fromJson(json);
    breed = breed.copyWith(id: 2, name: "test2");
    expect(breed.id, 2);
    expect(breed.name, "test2");
    
  });
  

}