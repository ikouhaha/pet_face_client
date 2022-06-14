import 'dart:convert';

import 'package:pet_saver_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? sharedPrefs;

  static save(String key, dynamic value) {
    if (value is bool) {
      sharedPrefs?.setBool(key, value);
    } else if (value is String) {
      sharedPrefs?.setString(key, value);
    } else if (value is int) {
      sharedPrefs?.setInt(key, value);
    } else if (value is double) {
      sharedPrefs?.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs?.setStringList(key, value);
    }
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
