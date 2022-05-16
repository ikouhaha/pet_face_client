// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/models/storage.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/signin_scaffold.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';

import 'scaffold_body.dart';

final storeageProvider = FutureProvider<Storage>((ref) async {
  Storage storage = await ref.read(GlobalProvider).getStorage();
  return storage;
});

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  MyScaffoldState createState() => MyScaffoldState();

}

class MyScaffoldState extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);
        return Scaffold(
            drawer: Drawer(
                child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(child: Text('Pet Saver',style: TextStyle(color: Colors.white,fontSize: 16.0),)),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            )),
            appBar: AppBar(),
            body: AdaptiveNavigationScaffold(
              selectedIndex: selectedIndex,
              body: const BookstoreScaffoldBody(),
              onDestinationSelected: (idx) {
                print(idx);
                if (idx == 0) routeState.go('/');
                 if (idx == 1) routeState.go('/message');
                if (idx == 2) routeState.go('/new/post');
               
                if (idx == 3) routeState.go('/mypost');
                if (idx == 4) routeState.go('/settings');
              },
              destinations: const [
                AdaptiveScaffoldDestination(
                  title: 'Books',
                  icon: Icons.home,
                ),
                 AdaptiveScaffoldDestination(
                  title: 'Message',
                  icon: Icons.comment,
                ),
                AdaptiveScaffoldDestination(
                  title: 'Post',
                  icon: Icons.post_add,
                ),
               
                AdaptiveScaffoldDestination(
                  title: 'My Post',
                  icon: Icons.location_history,
                ),
                  AdaptiveScaffoldDestination(
                  title: 'Settings',
                  icon: Icons.settings,
                ),
              ],
            ));
     
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate == '/') return 0;
     if (pathTemplate == '/message') return 1;
    if (pathTemplate == '/new/post') return 2;
   
    if (pathTemplate == '/mypost') return 3;
    if (pathTemplate == '/settings') return 4;
    return 0;
  }
}
