import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/firebase_options.dart';
import 'package:pet_saver_client/pages/splash.dart';


String get testEmulatorHost {
  if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
    return '10.0.2.2';
  }
  return 'localhost';
}

const int testEmulatorPort = 9099;

void main() {
  setUpAll(
    () async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    },
  );

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('load empty page', (tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const Splash()));

    await tester.pumpAndSettle();

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "ikouhaha888@gmail.com", password: "ikouhaha765");

    
  });
}
