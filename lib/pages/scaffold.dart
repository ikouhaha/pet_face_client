import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/notifications.dart';
import 'package:pet_saver_client/router/route_state.dart';

import 'scaffold_body.dart';

class MyScaffold extends ConsumerStatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  MyScaffoldState createState() => MyScaffoldState();
}

class MyScaffoldState extends ConsumerState {
  int previousSelectIndex = 0;
  late FirebaseDatabase database;
  late DatabaseReference notificationsListRef;
  UserModel? profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = FirebaseDatabase.instanceFor(
        app: FirebaseDatabase.instance.app, databaseURL: Config.firebaseRDBUrl);
    profile = SharedPreferencesService.getProfile();
    if (profile?.role == "staff") {
      notificationsListRef = database
          .ref()
          .child("notifications")
          .child(profile?.companyCode.toString() ?? "");
    } else if (profile?.role == "user") {
      notificationsListRef = database
          .ref()
          .child("notifications")
          .child(profile?.id.toString() ?? "");
    }
  }

  Text getTitle(String path, int idx) {
    String title = "";
    if (idx == 0) {
      title = "Pet Saver";
    } else if (idx == 1) {
      title = "Create Post";
    } else if (idx == 2) {
      title = "My Post";
    } else if (idx == 3) {
      title = "Settings";
    }

    return Text(title);
  }

  ListTile getSigninout() {
    if (FirebaseAuth.instance.currentUser == null) {
      return ListTile(
        title: Text("Sign In"),
        onTap: () {
          RouteStateScope.of(context).go("/signin");
        },
      );
    } else {
      return ListTile(
          title: Text("Sign Out", style: TextStyle(color: Colors.redAccent)),
          onTap: () {
            FirebaseAuth.instance.signOut();
            RouteStateScope.of(context).go("/signin");
          });
    }
  }

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
            getSigninout()
          ],
        )),
        appBar: AppBar(
          title: getTitle(routeState.route.pathTemplate, selectedIndex),
          actions: [
            StreamBuilder(
              stream: notificationsListRef.onValue,
              builder: (context, snapshot) {
                var goLink = () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                var emptyNotification = IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    goLink();
                  },
                );

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return emptyNotification;
                }
                if (snapshot.hasData) {
                  var data = (snapshot.data! as DatabaseEvent).snapshot.value;

                  if (data == null) {
                    return emptyNotification;
                  }
                  data = data as Map<dynamic, dynamic>;

                  var count = data.length;

                  if (count > 0) {
                    return IconButton(
                      padding: EdgeInsets.only(right: 15),
                        icon: Badge(
                      badgeContent: Text(count.toString(), style: TextStyle(color: Colors.white)),
                      child: IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          goLink();
                        },
                      ),
                    ),
                        onPressed: () {
                          goLink();
                        },
                      );
                    
                  } else {
                    return emptyNotification;
                  }
                } else {
                  return emptyNotification;
                }
              },
            )
          ],
        ),
        body: AdaptiveNavigationScaffold(
          selectedIndex: selectedIndex,
          body: const BookstoreScaffoldBody(),
          onDestinationSelected: (idx) {
            if (idx == 0) routeState.go('/');

            if (idx == 1) routeState.go('/new/post');

            if (idx == 2) routeState.go('/mypost');
            if (idx == 3) routeState.go('/settings');
          },
          destinations: const [
            AdaptiveScaffoldDestination(
              title: 'Home',
              icon: Icons.home,
            ),
            // AdaptiveScaffoldDestination(
            //   title: 'Message',
            //   icon: Icons.comment,
            // ),
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
      previousSelectIndex = 0;
      return 0;
    } else if (pathTemplate == "/new/post") {
      previousSelectIndex = 1;
      return 1;
    } else if (pathTemplate == "/mypost") {
      previousSelectIndex = 2;
      return 2;
    } else if (pathTemplate == "/settings") {
      previousSelectIndex = 3;
      return 3;
    }

    return previousSelectIndex;
  }
}
