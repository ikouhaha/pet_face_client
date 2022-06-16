import 'dart:convert';

import 'package:pet_saver_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? sharedPrefs;

  static save(String key, dynamic value) async {
    if (value is bool) {
      await sharedPrefs?.setBool(key, value);
    } else if (value is String) {
      await sharedPrefs?.setString(key, value);
    } else if (value is int) {
      await sharedPrefs?.setInt(key, value);
    } else if (value is double) {
      await sharedPrefs?.setDouble(key, value);
    } else if (value is List<String>) {
      await sharedPrefs?.setStringList(key, value);
    }
  }

   static getString(String key) {
   
      return sharedPrefs?.getString(key);
  }

  static remove(String key) async {
      await sharedPrefs?.remove(key);
  }

  static saveProfile(UserModel profile) {
   
    save("profile", jsonEncode(profile.toJson()));
  }

  static UserModel? getProfile() {
    var profile = sharedPrefs?.getString("profile");

    if(profile!=null){
      Map<String,dynamic> deCodeProfile = jsonDecode(profile);
      return UserModel.fromJson(deCodeProfile);
    }

    return null;
  }
}
