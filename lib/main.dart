import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigator_v2/common/app_bloc_observer.dart';
import 'package:flutter_navigator_v2/pages/home.dart';
import 'package:flutter_navigator_v2/router/route_parser.dart';
import 'package:flutter_navigator_v2/router/router_delegate.dart';

void main() {

   BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );

  //runApp(const );

  
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final delegate = MyRouteDelegate(
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return const HomePage();
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routeInformationParser: MyRouteParser(), // 路由信息解析
      routerDelegate: delegate, // 路由代理
    );
  }
}