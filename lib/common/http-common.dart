import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';

import 'package:pet_saver_client/providers/global_provider.dart';

class Http {
  static Dio? _dio;
  static bool _autoPopup = true;

  static void setDio({Dio? dio}){
    _dio = dio;
  }
  static void setAutoPopup({bool autoPopup = true}) {
    _autoPopup = autoPopup;
  }

  static String getErrorMsg({ex}) {
    String errorMessage = "";
    if (ex.response != null &&
        ex.response.statusCode != null &&
        ex.response.statusCode == 401) {
      if (ex.response.statusMessage != null) {
        errorMessage = ex.response.statusMessage;
        //EasyLoading.showError(errorMessage);

      }
    }  else if (ex.response != null &&
        ex.response.data != null &&
        !(ex.response.data is String) &&
        ex.response.data["stack"] != null) {
      errorMessage = ex.response.data["stack"];
    } else if (ex.response != null &&
        ex.response.data != null &&
        !(ex.response.data is String) &&
        ex.response.data["message"] != null) {
        errorMessage = ex.response.data["message"];
    } else if (ex.response != null &&
        ex.response.data != null &&
        !(ex.response.data is String) &&
        ex.response.data["result"] != null) {
        errorMessage = ex.response.data["result"];
    } else if (ex.response != null && ex.response.data != null) {
      errorMessage = ex.response.data;
    } else if (ex.response != null && ex.response.message != null) {
      errorMessage = ex.response.message;
    } else if (ex.message != null) {
      errorMessage = ex.message;
    } else if (ex != null) {
      errorMessage = ex;
    }

    return errorMessage;
  }

  static Future<Response> get(
      { required url, authorization, String? server}) async {
        var dio = _dio??Dio();
    try {
      //print(navigatorKey.currentContext);
      
      
      if (authorization != null) {
        dio.options.headers["Authorization"] = authorization;
      }else{
        dio.options.headers["Authorization"] = SharedPreferencesService.getString("token"); 
      }
      Response response = await dio.get((server ?? Config.apiServer )+ url);
      return response;
    } on DioError catch (ex) {
      print(ex);
      String errorMsg = getErrorMsg(ex: ex);
      if (ex.response != null && ex.response!.statusCode == 401) {
       // await ref.read(GlobalProvider).logout();
       throw Exception(ex.response!.statusCode);
      } else {
        if(_autoPopup){
           EasyLoading.showError(errorMsg);
        }
       
      }

      throw Exception(errorMsg);
    }finally{
      dio.close();
    }
  }

  static Future<Response> post(
      { required url, data, authorization, String? server}) async {
         var dio = _dio??Dio();
    try {
     
      if (authorization != null) {
        dio.options.headers["Authorization"] = authorization;
      }else{
        dio.options.headers["Authorization"] = SharedPreferencesService.getString("token"); 
      }
      Response response = await dio.post((server ?? Config.apiServer )+ url, data: data);
      return response;
    } on DioError catch (ex) {
      String errorMsg = getErrorMsg(ex: ex);
      if (ex.response != null && ex.response!.statusCode == 401) {
        //await ref.read(GlobalProvider).logout();
        if (ex.response!.statusMessage != null) {
          if(_autoPopup)
          EasyLoading.showError(ex.response!.statusMessage!);
        }
      } else {
        if(_autoPopup)
        EasyLoading.showError(errorMsg);
      }

      throw Exception(errorMsg);
    }finally{
      dio.close();
    }
  }

  static Future<Response> put(
      { required url, data, authorization, String? server}) async {
        var dio = _dio??Dio();
    try {
    
      if (authorization != null) {
        dio.options.headers["Authorization"] = authorization;
      }else{
       dio.options.headers["Authorization"] = SharedPreferencesService.getString("token"); 
      }

      Response response = await dio.put((server ?? Config.apiServer )+ url, data: data);
      return response;
    } on DioError catch (ex) {
      String errorMsg = getErrorMsg(ex: ex);
      if (ex.response != null && ex.response!.statusCode == 401) {
        //await ref.read(GlobalProvider).logout();
        if (ex.response!.statusMessage != null) {
          if(_autoPopup)
          EasyLoading.showError(ex.response!.statusMessage!);
        }
      } else {
        if(_autoPopup)
        EasyLoading.showError(errorMsg);
      }

      throw Exception(errorMsg);
    }finally{
      dio.close();
    }
  }

  static Future<Response> delete(
      { required url, authorization, String? server}) async {
        var dio = _dio??Dio();
    try {
     
      if (authorization != null) {
        dio.options.headers["Authorization"] = authorization;
      }else{
        dio.options.headers["Authorization"] = SharedPreferencesService.getString("token"); 
      }

      Response response = await dio.delete((server ?? Config.apiServer )+ url);
      return response;
    } on DioError catch (ex) {
      String errorMsg = getErrorMsg(ex: ex);
      if (ex.response != null && ex.response!.statusCode == 401) {
        //await ref.read(GlobalProvider).logout();
        if (ex.response!.statusMessage != null) {
          if(_autoPopup)
          EasyLoading.showError(ex.response!.statusMessage!);
        }
      } else {
        if(_autoPopup)
        EasyLoading.showError(errorMsg);
      }
    
      throw Exception(errorMsg);
    }finally{
      dio.close();
    }
  }

  static Future<Response> postImage(
      {required url, required XFile imageFile, String? server, String? name}) async {
    var dio = _dio??Dio();
    try {
      
      dio.options.headers["Connection"] ="Keep-Alive" ;
      FormData body = FormData();
      var bytes = await imageFile.readAsBytes();
      final MultipartFile file = MultipartFile.fromBytes(bytes, filename: imageFile.name);
      String orginalImageBase64 = base64Encode(bytes);
      MapEntry<String, MultipartFile> imageEntry = MapEntry("image", file);
      body.files.add(imageEntry);
      if(name!=null){
        body.fields.add(MapEntry("name", name));
      }
      
     
    
      // get file length
      var length = await imageFile.length();
      String _server = server ?? Config.apiServer;
      print(_server+url);
    
      Response response = await dio.post(
      _server+url,
      data: body,
    );
      response.data["orginalImageBase64"] = orginalImageBase64;
      
      return response;
    } on DioError catch (ex) {
      String errorMsg = getErrorMsg(ex: ex);    
      if(_autoPopup)  
      EasyLoading.showError(errorMsg);
      throw Exception(errorMsg);
    }finally{
      dio.close();
    }
  }
}
