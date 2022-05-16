import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/models/storage.dart';
import 'package:pet_saver_client/models/user.dart';


enum AuthenticationStatus { unknown, authenticated, unauthenticated }

final ChangeNotifierProvider<GlobalNotifier> GlobalProvider =
    ChangeNotifierProvider((_) => GlobalNotifier());

class GlobalNotifier extends ChangeNotifier {
  final mobileStorage = new FlutterSecureStorage();  
  AuthenticationStatus _status = AuthenticationStatus.authenticated;
  String token = "";
   
  get status => this._status;
  get isAuthenticated => this._status== AuthenticationStatus.authenticated;
  


  Future<void> login({bool? isRegister,token}) async{
    await mobileStorage.write(key: "token", value: token);
    this._status = AuthenticationStatus.authenticated;    
    this.token = token;
    notifyListeners();
  }

  void setAuthenticated() {
    this._status=AuthenticationStatus.authenticated;
    notifyListeners();
  }


  void logout() async {
    await mobileStorage.delete(key: "token");
    this.token = "";
    this._status = AuthenticationStatus.unauthenticated;
    notifyListeners();
  }

  Future<UserModel> fetchProfile({required  ref}) async {
    var token = await mobileStorage.read(key: "token");    
    var response = await Http.get(url: "/users/profile");
    this.token = token??"";
    UserModel userModel = UserModel.fromJson(response.data);
    return userModel;
  }



  Future<Storage> getStorage() async {
     var fstore = new FlutterSecureStorage();
      var token = await fstore.read(key: 'token');
      this.token = token??"";
      Storage storage = new Storage(token: token??'');
      return storage;
  }


  @override
  String toString() {
    // TODO: implement toString
    return "status: ${status.toString()}";
  }

}
