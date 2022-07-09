import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/firebase_options.dart';
import 'package:pet_saver_client/pages/splash.dart';

class MockDefaultFirebaseOptions extends Mock
    implements DefaultFirebaseOptions {
  //   static var mock = FirebaseOptions(apiKey: 'test',appId: 'test',authDomain: 'test',databaseURL: 'test',storageBucket: 'test', messagingSenderId: 'test',projectId: 'test',measurementId: 'test');
   FirebaseOptions get currentPlatforma {
    return DefaultFirebaseOptions.currentPlatform;
  }



    FirebaseOptions web = DefaultFirebaseOptions.web;
    FirebaseOptions android = DefaultFirebaseOptions.android;
    FirebaseOptions ios = DefaultFirebaseOptions.ios;

}

class Functions {
  void onListen() {}
}

class MockFunctions extends Mock implements Functions {}

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  test('get firebase options currentPlatform', () {
    var test = DefaultFirebaseOptions.currentPlatform;
    //default android
    expect(test, DefaultFirebaseOptions.android);
  });

  test('get firebase options ios', () {
    MockDefaultFirebaseOptions mock = MockDefaultFirebaseOptions();
    expect(mock.ios, mock.ios);
  });

   test('get firebase options ios', () {
    MockDefaultFirebaseOptions mock = MockDefaultFirebaseOptions();
    expect(mock.web, mock.web);
  });

  
}
