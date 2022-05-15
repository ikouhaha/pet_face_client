import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/components/change_pwd_card.dart';
import 'package:pet_saver_client/components/profile_card.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/list.dart';
import 'package:pet_saver_client/pages/register.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _getProfileProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  return ref.read(GlobalProvider).fetchProfile(ref: ref);
});

final StateNotifierProvider<SettingPageState, int>
    SettingPageProvider =
    StateNotifierProvider<SettingPageState, int>((_) => SettingPageState());

class SettingPageState extends StateNotifier<int> {
  SettingPageState() : super(0);



  void setState(num) => {state = num};

 

  @override
  String toString() {
    return 'state：$state';
  }
}


class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  RouteState get _routeState => RouteStateScope.of(context);

  // void _handleBookTapped(Book book) {
  //   _routeState.go('/book/${book.id}');
  // }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(_getProfileProvider);

    return provider.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (err, stack) => Text('Error: $err'),
        data: (profile) {
          print(profile.toJson());

          return Scaffold(
            body: Stack(children: [
              Positioned.fill(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
                      child: Container(
                          margin:EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ProfileCard(user: profile),
                          ChangePwdCard(user: profile),
                          _LogoutButton(),
                          // const _SignUpButton(),
                        ],
                      ))))
            ]),
          );
        });
  }
}

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Consumer(
      builder: (context, ref, child) {
        // print("------status-----");
        // print(state.status.isValidated);
        

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text('Logout'),
                disabledColor: Colors.blueAccent.withOpacity(0.6),
                color: Colors.redAccent,
                onPressed:()=> ref.read(GlobalProvider).logout()));
      },
    );
  }
}