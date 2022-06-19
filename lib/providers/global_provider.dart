import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  AuthenticationStatus _status = AuthenticationStatus.authenticated;
  String token = "";
   
  get status => this._status;
  get isAuthenticated => this._status== AuthenticationStatus.authenticated;
  


  Future<void> login({bool? isRegister,token}) async{
  
    this._status = AuthenticationStatus.authenticated;    
    this.token = token;
    notifyListeners();
  }

  void setAuthenticated() {
    this._status=AuthenticationStatus.authenticated;
    notifyListeners();
  }


  void logout() async {
  
    this.token = "";
    this._status = AuthenticationStatus.unauthenticated;
    notifyListeners();
  }



  @override
  String toString() {
    // TODO: implement toString
    return "status: ${status.toString()}";
  }

}
