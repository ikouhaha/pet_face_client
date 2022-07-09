import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/pages/editPost.dart';
import 'package:pet_saver_client/pages/home.dart';
import 'package:pet_saver_client/pages/list.dart';
import 'package:pet_saver_client/pages/mypost.dart';
import 'package:pet_saver_client/pages/notifications.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
return MaterialApp(
  home: Scaffold(
    body: child,
  ),
);
}

  testWidgets('load notifications page', (tester) async {
   
    await tester.pumpWidget(createWidgetForTesting(child: const NotificationPage()));

    await tester.pumpAndSettle();
  });
}
