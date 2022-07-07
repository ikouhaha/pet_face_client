import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/pages/splash.dart';

import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
    const successMessage = {'message': 'Success'};



  const path = 'https://example.com';

 

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: child,
    );
  }

  test('test Http get', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio!);
     dio!.httpClientAdapter = dioAdapter!;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter!.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(200, successMessage);
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


   
    final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
     expect(response.data, successMessage);
     //await tester.pumpAndSettle();

  });

  
  test('test Http get message error', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(500, {'message': 'error'});
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


    try{
      final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
    } on dynamic catch( e){
      expect(e.message, "error");

    }
  });

   test('test Http get 401 error', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(401, {'message': 'error'},statusMessage: "Unauthorized");
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


    try{
      final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
    } on dynamic catch( e){
      expect(e.message, 401);
      // expect(e.message, "error");
      
    }
  });

  
   test('test Http get data stack error', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(500, {'stack': 'error'});
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


    try{
      final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
    } on dynamic catch( e){
      expect(e.message, "error");
      // expect(e.message, "error");
      
    }
  });

    test('test Http get data result error', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(500, {'result': 'error'});
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


    try{
      final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
    } on dynamic catch( e){
      expect(e.message, "error");
      // expect(e.message, "error");
      
    }
  });

  test('test Http get data error', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onGet(
      'https://example.com/test',
      (request) {
        return request.reply(500,"error");
      },
      data: null,
      queryParameters: {},
      headers: {},
    );


    try{
      final response = await Http.get(url: "/test", authorization: "Bearer 12345",server: "https://example.com");
    } on dynamic catch( e){
      expect(e.message, "error");
      // expect(e.message, "error");
      
    }
  });


    test('test Http post', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
        var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onPost(
      'https://httpbin.org/post',
      (request) {
        return request.reply(200, successMessage);
      },
      data: {},
      queryParameters: {},
      headers: {},
    );

    
  
   
    final response = await Http.post(url: "/post", authorization: "Bearer 12345",server: "https://httpbin.org",data: {});
     expect(response.data, successMessage);
     //await tester.pumpAndSettle();

  });

   test('test Http put', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
    var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio!);
     dio!.httpClientAdapter = dioAdapter!;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter!.onPut(
      'https://httpbin.org/put',
      (request) {
        return request.reply(200, successMessage);
      },
      data: {},
      queryParameters: {},
      headers: {},
    );

   
    final response = await Http.put(url: "/put", authorization: "Bearer 12345",server: "https://httpbin.org",data: {});
     expect(response.data, successMessage);
     //await tester.pumpAndSettle();

  });


   test('test Http delete', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
    var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onDelete(
      'https://httpbin.org/delete',
      (request) {
        return request.reply(200, successMessage);
      },
      data: null,
      queryParameters: {},
      headers: {},
    );

   
    final response = await Http.delete(url: "/delete", authorization: "Bearer 12345",server: "https://httpbin.org");
     expect(response.data, successMessage);
     //await tester.pumpAndSettle();

  });


   test('test Http post Image', () async {
      //await tester.pumpWidget(createWidgetForTesting(child: const Splash()));
    var img64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=";
    var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
     dioAdapter.onPost(
      "https://pet-saver-aiapi.azurewebsites.net/detectBase64/0",
      (request) {
        return request.reply(200, successMessage,delay: const Duration(seconds: 1));
      }
    );

    var file = XFile.fromData(base64Decode(img64));
     
     //await tester.pumpAndSettle();
    final response = await Http.postImage(url: "/detectBase64/0",server: "https://pet-saver-aiapi.azurewebsites.net",name: "test"
    ,imageFile: file);
     expect(response.data, successMessage);
     //await tester.pumpAndSettle();

  });

}
