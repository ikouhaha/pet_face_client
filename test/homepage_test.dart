import 'package:dio/dio.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/editPost.dart';
import 'package:pet_saver_client/pages/home.dart';
import 'package:pet_saver_client/pages/navigator.dart';
import 'package:pet_saver_client/router/delegate.dart';
import 'package:pet_saver_client/router/parsed_route.dart';
import 'package:pet_saver_client/router/parser.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'data.dart';
import 'mock.dart';

void main() {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  setupFirebaseAuthMocks();

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    return from;
  }

  setUpAll(() async {
    await Firebase.initializeApp();
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/',
        '/splash',
        '/notifications',
        '/signin',
        '/signup',
        '/post',
        '/settings',
        '/mypost',
        '/new/post',
        '/edit/post/:id',
        '/post/:id'
      ],
      guard: _guard,
    );
    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => MyNavigator(
        navigatorKey: _navigatorKey,
      ),
    );
  });
  Widget createWidgetForTesting({required Widget child}) {
    return ProviderScope(
      child: MaterialApp(
          builder: EasyLoading.init(),
          home: RouteStateScope(
            notifier: _routeState,
            child: child,
          )),
    );
  }

  testWidgets('load home page test mode 1', (tester) async {
    Config.isTest = true;
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);

    var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio: dio);
    Http.setAutoPopup(autoPopup: false);
    dioAdapter.onGet(Config.apiServer + "/options/breeds/cat", (request) {
      return request.reply(200, TestData.catBreeds,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/options/breeds/dog", (request) {
      return request.reply(200, TestData.dogBreeds,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/options/districts", (request) {
      return request.reply(200, TestData.districts,
          delay: const Duration(seconds: 1));
    });

    dioAdapter.onGet(Config.apiServer + "/posts?page=1&limit=1000&", (request) {
      return request.reply(200, TestData.postList,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/api/v1/posts/image/36", (request) {
      return request.reply(200, {}, delay: const Duration(seconds: 1));
    });

    //when(FirebaseAuth.instance.currentUser).thenAnswer((_) => auth.currentUser);

    SharedPreferencesService.sharedPrefs =
        await SharedPreferences.getInstance();
    UserModel profile = UserModel(
        id: 1,
        email: 'test@gmail.com',
        username: 'test',
        displayName: 'test',
        role: 'user',
        avatarUrl:
            'https://lh3.googleusercontent.com/a/AATXAJyzetG1ehaZy7LI0Wanz3LIuL87iETNNtLrIxPo=s96-c',
        dateRegistered: DateTime.now());
    SharedPreferencesService.saveProfile(profile);
     await tester.pumpWidget(createWidgetForTesting(child: const HomePage()));

    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(Duration(seconds: 1));
    }

    Config.testMode = "1";
    expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
      await tester.pump(Duration(seconds: 5));
     await tester.tap(find.byType(FloatingActionButton));
     await tester.pump();
    
  });

    testWidgets('load home page test mode 2', (tester) async {
    Config.isTest = true;
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);

    var dio = Dio();
    var dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    Http.setDio(dio: dio);
    Http.setAutoPopup(autoPopup: false);
    dioAdapter.onGet(Config.apiServer + "/options/breeds/cat", (request) {
      return request.reply(200, TestData.catBreeds,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/options/breeds/dog", (request) {
      return request.reply(200, TestData.dogBreeds,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/options/districts", (request) {
      return request.reply(200, TestData.districts,
          delay: const Duration(seconds: 1));
    });

    dioAdapter.onGet(Config.apiServer + "/posts?page=1&limit=1000&", (request) {
      return request.reply(200, TestData.postList,
          delay: const Duration(seconds: 1));
    });
    dioAdapter.onGet(Config.apiServer + "/api/v1/posts/image/36", (request) {
      return request.reply(200, {}, delay: const Duration(seconds: 1));
    });

    //when(FirebaseAuth.instance.currentUser).thenAnswer((_) => auth.currentUser);

    SharedPreferencesService.sharedPrefs =
        await SharedPreferences.getInstance();
    UserModel profile = UserModel(
        id: 1,
        email: 'test@gmail.com',
        username: 'test',
        displayName: 'test',
        role: 'user',
        avatarUrl:
            'https://lh3.googleusercontent.com/a/AATXAJyzetG1ehaZy7LI0Wanz3LIuL87iETNNtLrIxPo=s96-c',
        dateRegistered: DateTime.now());
    SharedPreferencesService.saveProfile(profile);
     await tester.pumpWidget(createWidgetForTesting(child: const HomePage()));

    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(Duration(seconds: 1));
    }

    Config.testMode = "2";
    expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
     await tester.pump(Duration(seconds: 5));
     await tester.tap(find.byType(FloatingActionButton));
     await tester.pump();
    
  });
}
