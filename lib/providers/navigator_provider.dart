import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final StateNotifierProvider<NavigatorNameState, String>
    // ignore: non_constant_identifier_names
    NavigatorProvider =
    StateNotifierProvider<NavigatorNameState, String>((_) => NavigatorNameState());

class NavigatorNameState extends StateNotifier<String> {
  NavigatorNameState() : super('');
  void setState(String name) => {state = name};

  @override
  String toString() {
    return 'state：$state';
  }
}


final StateNotifierProvider<NavigatorKeyState, GlobalKey<NavigatorState>>
    navigatorKeyProvider =
    StateNotifierProvider<NavigatorKeyState, GlobalKey<NavigatorState>>((_) => NavigatorKeyState());

class NavigatorKeyState extends StateNotifier<GlobalKey<NavigatorState>> {
  NavigatorKeyState() : super(GlobalKey<NavigatorState>());

  @override
  String toString() {
    return 'state：$state';
  }
}

