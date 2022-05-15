
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_navigator_v2/cubit/login_cubit.dart';
import 'package:flutter_navigator_v2/pages/home.dart';
import 'package:flutter_navigator_v2/pages/list.dart';
import 'package:flutter_navigator_v2/pages/login_scaffold.dart';

final routerNames = {
  "/": (context) => const HomePage(),
  "/list": (context) => const ListPage(),
  "/login": (context) => const LoginScaffold()

  
};

//routerNames["/login"] = (context) => const ListPage()