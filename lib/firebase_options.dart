// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCenQghL8kNh2uXhjY7zeHGH8sTN7kvsrY',
    appId: '1:544220858909:web:d4fbd6ed0d05f9cbdd14f4',
    messagingSenderId: '544220858909',
    projectId: 'petsaver-81af2',
    authDomain: 'petsaver-81af2.firebaseapp.com',
    storageBucket: 'petsaver-81af2.appspot.com',
    measurementId: 'G-VXJQV1PJYR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1lt55n-Ey9ANv7iMylgb48z_otVhzDro',
    appId: '1:544220858909:android:cbe379b7a06eedacdd14f4',
    messagingSenderId: '544220858909',
    projectId: 'petsaver-81af2',
    storageBucket: 'petsaver-81af2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBgDpTRzU90J6QvoL04w-3TtvEDLh_ohE',
    appId: '1:544220858909:ios:fd8c5ac64c2c89a2dd14f4',
    messagingSenderId: '544220858909',
    projectId: 'petsaver-81af2',
    storageBucket: 'petsaver-81af2.appspot.com',
    androidClientId: '544220858909-ltnnkg4brkulai9010uhmfavlic21tv5.apps.googleusercontent.com',
    iosClientId: '544220858909-gir5kmmotpkhadbfe8iu08u999rerh7h.apps.googleusercontent.com',
    iosBundleId: 'com.example.petSaverClient',
  );
}