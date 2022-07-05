import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
// import 'package:mockito/annotations.dart';

import 'mock.dart';


String get testEmulatorHost {
  if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
    return '10.0.2.2';
  }
  return 'localhost';
}

const int testEmulatorPort = 9099;

void main() {
  setupFirebaseAuthMocks();
  FirebaseAuth? auth;
  MockFirebaseAuth mockAuthPlatform = MockFirebaseAuth();
  var testCount = 0;

   setUpAll(() async{
    final app = await Firebase.initializeApp(
        name: '$testCount',
        options: const FirebaseOptions(
          apiKey: '',
          appId: '',
          messagingSenderId: '',
          projectId: '',
        ),
      );
    FirebaseAuthPlatform.instance =  mockAuthPlatform = FirebaseAuthPlatform;
    auth = FirebaseAuth.instanceFor(app: app);
   });

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('load empty page', (tester) async {
    
    await tester.pumpWidget(createWidgetForTesting(child: const Splash()));

    await tester.pumpAndSettle();

    await auth?.signInWithEmailAndPassword(
        email: "ikouhaha888@gmail.com", password: "ikouhaha765");

    print(FirebaseAuth.instance.currentUser);
    
  });
}
