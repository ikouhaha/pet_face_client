import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {

  Widget createWidgetForTesting({required Widget child}){
return MaterialApp(
  home:  Scaffold(body: child)
  
);
}

  testWidgets('load auth text', (tester) async {
    FormController _password = FormController();
    await tester.pumpWidget(createWidgetForTesting(
      child:  AuthTextField(
      key: const Key('pwd'),
        focusNode:_password.fn,
        controller: _password.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Password',
        isPasswordField: true,
        
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => Validations.validatePassword(value))
    
    ));

    await tester.pumpAndSettle();
  });
}
