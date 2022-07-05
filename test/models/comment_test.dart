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
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('test comment',(){
    int now = DateTime.now().microsecondsSinceEpoch;
    Comment comment = Comment();
    comment.key = "test";
    comment.postOwner = 1;
    comment.commentById = 1;
    comment.replyTo = 1;
    comment.companyCode = "111";
    comment.postId = 1;
    comment.comment = "test";
    comment.commentDate = now;
    comment.commentBy = "test";
    
    expect(comment.key, "test");
    expect(comment.postOwner, 1);
    expect(comment.commentById, 1);
    expect(comment.replyTo, 1);
    expect(comment.companyCode, "111");
    expect(comment.postId, 1);
    expect(comment.comment, "test");
    expect(comment.commentDate, now);
    expect(comment.commentBy, "test");
  });

  test('test commentFromJson',(){
    var list = commentFromJson("[{\"key\":\"test\",\"postOwner\":1,\"commentById\":1,\"replyTo\":1,\"companyCode\":\"111\",\"postId\":1,\"comment\":\"test\",\"commentDate\":1579098984,\"commentBy\":\"test\"}]");
    expect(list, isNotNull);
   
  });


  test('test commentToJson',(){
   List<Comment> comments = [];
    Comment comment = Comment(key: "test", postOwner: 1, commentById: 1, replyTo: 1, companyCode: "111", postId: 1, comment: "test", commentDate: 1579098984, commentBy: "test");
    comments.add(comment);
    var json = commentToJson(comments);
    expect(json, isNotNull);

  });

   test('test comment.fromJson',(){
    var json = {
      "key": "test",
      "postOwner": 1,
      "commentById": 1,
      "replyTo": 1,
      "companyCode": "111",
      "postId": 1,
      "comment": "test",
      "commentDate": 1579098984,
      "commentBy": "test"
    };
    
    
    Comment comment = Comment.fromJson(json);
    expect(comment.key, "test");
    expect(comment.postOwner, 1);
    expect(comment.commentById, 1);
    expect(comment.replyTo, 1);
    expect(comment.companyCode, "111");
    expect(comment.postId, 1);
    expect(comment.comment, "test");
    expect(comment.commentDate, 1579098984);
    expect(comment.commentBy, "test");

  });
  
  test('test comment.toJson',(){
    var json = {
      "key": "test",
      "postOwner": 1,
      "commentById": 1,
      "replyTo": 1,
      "companyCode": "111",
      "postId": 1,
      "comment": "test",
      "commentDate": 1579098984,
      "commentBy": "test"
    };
  
    
    Comment comment = Comment.fromJson(json);
    var result = comment.toJson();
    expect(result, json);
    
  });
  
   test('test copywith',(){
     var json = {
      "id": 1,
      "name": "test"
    };
    
    Comment comment = Comment.fromJson(json);
    comment = comment.copyWith(key: "test2", postOwner: 2, commentById: 2, replyTo: 2, companyCode: "222", postId: 2, comment: "test2", commentDate: 1579098984, commentBy: "test2");
    expect(comment.key, "test2");
    expect(comment.postOwner, 2);
    expect(comment.commentById, 2);
    expect(comment.replyTo, 2);
    expect(comment.companyCode, "222");
    expect(comment.postId, 2);
    expect(comment.comment, "test2");
    expect(comment.commentDate, 1579098984);

    
  });
  

}