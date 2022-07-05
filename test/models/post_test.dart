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
import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  String img64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=";
  test('test PostModel',(){
    
    PostModel obj = PostModel();
    obj.type = "lost";
    obj.about = "test";
    obj.breedID = 1;
    obj.imageBase64 = img64;
    obj.createdBy = 1;
    obj.id = 1;
    obj.breed = "test";
    obj.createdByName = "test";
    obj.companyCode = "test";
    obj.imageFilename = "test.png";
    obj.petType = "cat";
    obj.cropImageBase64 = img64;
    obj.district = "test";
    obj.districtId = 1;

    expect(obj.type, "lost");
    expect(obj.about, "test");
    expect(obj.breedID, 1);
    expect(obj.imageBase64, img64);
    expect(obj.createdBy, 1);
    expect(obj.id, 1);
    expect(obj.breed, "test");
    expect(obj.createdByName, "test");
    expect(obj.companyCode, "test");
    expect(obj.imageFilename, "test.png");
    expect(obj.petType, "cat");
    expect(obj.cropImageBase64, img64);
    expect(obj.district, "test");
    expect(obj.districtId, 1);

  
  });

  test('test PostModelFromJson',(){
    var list = PostModelFromJson("[{\"type\":\"lost\",\"about\":\"test\",\"breedID\":1,\"imageBase64\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=\",\"createdBy\":1,\"id\":1,\"breed\":\"test\",\"createdByName\":\"test\",\"companyCode\":\"test\",\"imageFilename\":\"test.png\",\"petType\":\"cat\",\"cropImageBase64\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=\",\"district\":\"test\",\"districtId\":1}]");
    expect(list, isNotNull);
  
  });

  test('test PostModelObjFromJson',(){
    var obj = PostModelObjFromJson("{\"type\":\"lost\",\"about\":\"test\",\"breedID\":1,\"imageBase64\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=\",\"createdBy\":1,\"id\":1,\"breed\":\"test\",\"createdByName\":\"test\",\"companyCode\":\"test\",\"imageFilename\":\"test.png\",\"petType\":\"cat\",\"cropImageBase64\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=\",\"district\":\"test\",\"districtId\":1}");
    expect(obj, isNotNull);
  
  });


  test('test PostModelToJson',(){
   List<PostModel> list = [];
    PostModel obj = PostModel(
      type: "lost",
      about: "test",
      breedID: 1,
      imageBase64: img64,
      createdBy: 1,
      id: 1,
      breed: "test",
      createdByName: "test",
      companyCode: "test",
      imageFilename: "test.png",
      petType: "cat",
      cropImageBase64: img64,
      district: "test",
      districtId: 1,
    );

    
    list.add(obj);
    var json = PostModelToJson(list);
    expect(json, isNotNull);

  });

   test('test PostModel.fromJson',(){
    var json = {
      "type": "lost",
      "about": "test",
      "breedID": 1,
      "imageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "createdBy": 1,
      "id": 1,
      "breed": "test",
      "createdByName": "test",
      "companyCode": "test",
      "imageFilename": "test.png",
      "petType": "cat",
      "cropImageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "district": "test",
      "districtId": 1
    

    };
    
    
    
    PostModel obj = PostModel.fromJson(json);

    expect(obj.type, "lost");
    expect(obj.about, "test");
    expect(obj.breedID, 1);
    expect(obj.imageBase64, "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=");
    expect(obj.createdBy, 1);
    expect(obj.id, 1);
    expect(obj.breed, "test");
    expect(obj.createdByName, "test");
    expect(obj.companyCode, "test");
    expect(obj.imageFilename, "test.png");
    expect(obj.petType, "cat");
    expect(obj.cropImageBase64, "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=");
    expect(obj.district, "test");
    expect(obj.districtId, 1);


  });
  
  test('test PostModel.toJson',(){
    var json = {
      "type": "lost",
      "about": "test",
      "breedID": 1,
      "imageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "createdBy": 1,
      "id": 1,
      "breed": "test",
      "createdByName": "test",
      "companyCode": "test",
      "imageFilename": "test.png",
      "petType": "cat",
      "cropImageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "district": "test",
      "districtId": 1,
      "createdOn": "2020-01-01T00:00:00.000Z"
    };
    

    PostModel obj = PostModel.fromJson(json);
    var result = obj.toJson();
    expect(result, {
      "about": "test",
      "breedID": 1,
      "imageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "createdBy": 1,
      "id": 1,
      "type":"lost",
      "companyCode": "test",
      "imageFilename": "test.png",
      "petType": "cat",
      "cropImageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "districtId": 1
    
    });
    
  });
  
   test('test copywith',(){
       var json = {
      "type": "lost",
      "about": "test",
      "breedID": 1,
      "imageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "createdBy": 1,
      "id": 1,
      "breed": "test",
      "createdByName": "test",
      "companyCode": "test",
      "imageFilename": "test.png",
      "petType": "cat",
      "cropImageBase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      "district": "test",
      "districtId": 1
    

    
    };
    
    PostModel obj = PostModel.fromJson(json);
    obj = obj.copyWith(
      type: "found",
      about: "test2",
      breedID: 2,
      imageBase64: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=",
      createdBy: 2,
      id: 2,
      breed: "test",

      companyCode: "test2",
      imageFilename: "test.png",
      petType: "dog",
      
      district: "test",
      districtId: 1
    
    );
    
    expect(obj.type, "found");
    expect(obj.about, "test2");
    expect(obj.breedID, 2);
    expect(obj.imageBase64, "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=");
    expect(obj.createdBy, 2);
    expect(obj.id, 2);
    expect(obj.breed, "test");
    expect(obj.createdByName, "test");
    expect(obj.companyCode, "test2");
    expect(obj.imageFilename, "test.png");
    expect(obj.petType, "dog");
    expect(obj.cropImageBase64, "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=");
    expect(obj.district, "test");
    expect(obj.districtId, 1);

    
  });
  

}