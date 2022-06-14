import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/components/change_pwd_card.dart';
import 'package:pet_saver_client/components/profile_card.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState {
  UserModel? profile;
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushNamed('/login');
    }else{
      
    }
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _handleBookTapped(Book book) {
  //   _routeState.go('/book/${book.id}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ProfileCard(user: profile),
                        // ChangePwdCard(
                        //   user: profile,
                        //   key: Key("pwd"),
                        // ),
                        // _LogoutButton(),
                        // const _SignUpButton(),
                      ],
                    ))))
      ]),
    );
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
                onPressed: () {
                  ref.read(GlobalProvider).logout();
                  RouteStateScope.of(context).go("/");
                }));
      },
    );
  }
}
