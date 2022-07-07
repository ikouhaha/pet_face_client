import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';

import '../mock.dart';


void main() {

   setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  
  Widget createWidgetForTesting({required Widget child}){
    
return MaterialApp(
  home:  Scaffold(body: child)
  
);
}

  testWidgets('load auth text', (tester) async {
  
    await tester.pumpWidget(createWidgetForTesting(child:const App(key:Key("app"))));
    

    await tester.pumpAndSettle();
  });
}
