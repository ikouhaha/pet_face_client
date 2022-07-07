import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
return MaterialApp(
  home: child,
);
}

  testWidgets('load image field', (tester) async {
   
    await tester.pumpWidget(createWidgetForTesting(
      child:  ImageField(image: null, callback: (XFile , Function ) {  }, )
    
    ));

    await tester.pumpAndSettle();
  });
}
