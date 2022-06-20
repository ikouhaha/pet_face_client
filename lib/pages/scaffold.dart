// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/router/route_state.dart';

import 'scaffold_body.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  MyScaffoldState createState() => MyScaffoldState();
}

class MyScaffoldState extends State<MyScaffold> {
  int previousSelectIndex = 0;
  Text getTitle(String path, int idx) {
    String title = "";
    if (path == "/post/:id") {
      title = "Post Detail";
    } else if (idx == 0) {
      title = "Pet Saver";
    } else if (idx == 1) {
      title = "Message";
    } else if (idx == 2) {
      title = "Create Post";
    } else if (idx == 3) {
      title = "My Post";
    } else if (idx == 4) {
      title = "Settings";
    }

    return Text(title);
  }

  GestureDetector? getLeading(String path, int idx) {
    if (path == "/post/:id") {
      if (idx == 0) {
        return GestureDetector(
          onTap: () {
            RouteStateScope.of(context).go("/");
          },
          child: const Icon(
            Icons.arrow_back, // add custom icons also
          ),
        );
      } else if (idx == 3) {
        return GestureDetector(
          onTap: () {
            RouteStateScope.of(context).go("/mypost");
          },
          child: const Icon(
            Icons.arrow_back, // add custom icons also
          ),
        );
      }
    }
    if (idx == 0 && path == "/post/:id") {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);
    return Scaffold(
        endDrawer: Drawer(
            child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: Text(
                'Pet Saver',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              )),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                routeState.go('/');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Message'),
              onTap: () {
                routeState.go('/message');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Add Post'),
              onTap: () {
                routeState.go('/new/post');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('My Post'),
              onTap: () {
                routeState.go('/mypost');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Setting'),
              onTap: () {
                routeState.go('/settings');
                Navigator.of(context).pop();
              },
            ),
          ],
        )),
        appBar: AppBar(
          title: getTitle(routeState.route.pathTemplate,selectedIndex),
          leading: getLeading(routeState.route.pathTemplate, selectedIndex),
        ),
        body: AdaptiveNavigationScaffold(
          selectedIndex: selectedIndex,
          body: const BookstoreScaffoldBody(),
          onDestinationSelected: (idx) {
            if (idx == 0) routeState.go('/');
            if (idx == 1) routeState.go('/message');
            if (idx == 2) routeState.go('/new/post');

            if (idx == 3) routeState.go('/mypost');
            if (idx == 4) routeState.go('/settings');
          },
          destinations: const [
            AdaptiveScaffoldDestination(
              title: 'Home',
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

    if (pathTemplate == "/") {
      previousSelectIndex= 0;
      return 0;
    } else if (pathTemplate == "/message") {
      previousSelectIndex= 1;
      return 1;
    } else if (pathTemplate == "/new/post") {
      previousSelectIndex= 2;
      return 2;
    } else if (pathTemplate == "/mypost") {
      previousSelectIndex= 3;
      return 3;
    } else if (pathTemplate == "/settings") {
      previousSelectIndex= 4;
      return 4;
    }

    return previousSelectIndex;
  }
}
