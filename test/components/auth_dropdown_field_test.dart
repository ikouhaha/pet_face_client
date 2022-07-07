import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
return MaterialApp(
  home:  Scaffold(body: child)
  
);
}

  testWidgets('load auth dropdown', (tester) async {
     List<Option> postTypes = [];
     postTypes.add(Option(value: "lost", name: "Lost"));
    postTypes.add(Option(value: "found", name: "Found"));
    postTypes.add(Option(value: "adopt", name: "Adoption"));
    await tester.pumpWidget(createWidgetForTesting(
      child:  AuthDropDownField(
        key: const Key('post type'),
        icon: const Icon(Icons.question_mark),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Post Type',
        options: postTypes,
        onChanged: (value) {
         
        })
    
    ));

    await tester.pumpAndSettle();
  });
}
