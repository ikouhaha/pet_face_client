
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  test('test getSharedPreferences', () async {
    SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();
    expect(SharedPreferencesService.sharedPrefs, isNotNull);
  });

  test('test getString', () async {
    SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();
    expect(SharedPreferencesService.getString('test'), isNull);
  });

  test('test setString', () async {
    SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();
    SharedPreferencesService.save('test', 'test');
    expect(SharedPreferencesService.getString('test'), 'test');
  });
  
   test('test save Profile', () async {
    SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();
    UserModel profile = UserModel(
      id: 1,
      email: 'test@gmail.com',
      username: 'test',
      displayName: 'test',
      role: 'user',
      avatarUrl: 'https://lh3.googleusercontent.com/a/AATXAJyzetG1ehaZy7LI0Wanz3LIuL87iETNNtLrIxPo=s96-c',
      dateRegistered:DateTime.now()
      );
    SharedPreferencesService.saveProfile(profile);
    var expectResult = jsonEncode(profile.toJson());
    
    expect(SharedPreferencesService.getString('profile'), expectResult);
  });

   test('test get Profile', () async {
    SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();
    UserModel profile = UserModel(
      id: 1,
      email: 'test@gmail.com',
      username: 'test',
      displayName: 'test',
      role: 'user',
      avatarUrl: 'https://lh3.googleusercontent.com/a/AATXAJyzetG1ehaZy7LI0Wanz3LIuL87iETNNtLrIxPo=s96-c',
      dateRegistered:DateTime.now()

      );
    SharedPreferencesService.saveProfile(profile);
    var expectResult = jsonEncode(profile.toJson());
    var result =  jsonEncode(SharedPreferencesService.getProfile());
    
    expect(result, expectResult);
  });
 
}