import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/change_pwd_card.dart';
import 'package:pet_saver_client/components/profile_card.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('load change profile card', (tester) async {
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
    UserModel profile = UserModel(
        id: 1,
        email: 'test@gmail.com',
        username: 'test',
        displayName: 'test',
        role: 'user',
        avatarUrl:
            'https://lh3.googleusercontent.com/a/AATXAJyzetG1ehaZy7LI0Wanz3LIuL87iETNNtLrIxPo=s96-c',
        dateRegistered: DateTime.now());
    await tester.pumpWidget(createWidgetForTesting(
        child: ProfileCard(key: const Key('post type'), user: profile)));

    await tester.pumpAndSettle();
  });
}
