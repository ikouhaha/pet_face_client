import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/pages/signin_scaffold.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
return MaterialApp(
  home: Scaffold(
    body: child,
  ),
);
}

  testWidgets('load sign in page', (tester) async {
   
    await tester.pumpWidget(createWidgetForTesting(child: const LoginScaffold()));

    await tester.pumpAndSettle();
  });
}
