
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
