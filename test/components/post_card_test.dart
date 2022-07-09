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
import 'package:pet_saver_client/components/post_card.dart';
import 'package:pet_saver_client/components/profile_card.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/home.dart';
import 'package:pet_saver_client/pages/splash.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('load change profile card', (tester) async {
    String img64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=";
      var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
     dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio:dio);
    Http.setAutoPopup(autoPopup:false);
   PostModel obj = PostModel();
    obj.type = "lost";
    obj.about = "test";
    obj.breedID = 1;
    obj.imageBase64 = img64;
    obj.createdBy = 1;
    obj.id = 1;
    obj.breed = "test";
    obj.createdByName = "test";
    obj.companyCode = "test";
    obj.imageFilename = "test.png";
    obj.petType = "cat";
    obj.cropImageBase64 = img64;
    obj.district = "test";
    obj.districtId = 1;

    await tester.pumpWidget(createWidgetForTesting(
        child: PostCard(key: const Key('post type'), profile: obj)));

    await tester.pumpAndSettle();
  });
}
