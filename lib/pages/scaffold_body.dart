// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:pet_saver_client/pages/editPost.dart';
import 'package:pet_saver_client/pages/message.dart';
import 'package:pet_saver_client/pages/post.dart';
import 'package:pet_saver_client/pages/home.dart';
import 'package:pet_saver_client/pages/list.dart';
import 'package:pet_saver_client/pages/mypost.dart';
import 'package:pet_saver_client/pages/postDetail.dart';
import 'package:pet_saver_client/pages/setting.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:pet_saver_client/router/route_state.dart';

import '../widgets/fade_transition_page.dart';
import 'scaffold.dart';

/// Displays the contents of the body of [BookstoreScaffold]
class BookstoreScaffoldBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  
  const BookstoreScaffoldBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;

    // A nested Router isn't necessary because the back button behavior doesn't
    // need to be customized.
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        if (currentRoute.pathTemplate == ('/'))
           FadeTransitionPage<void>(
            key: ValueKey('Home'),
            child: HomePage(),
          )
        else if (currentRoute.pathTemplate== '/settings')
          const FadeTransitionPage<void>(
            key: ValueKey('settings'),
            child: SettingPage(),
          )
           else if (currentRoute.pathTemplate== '/mypost')
          const FadeTransitionPage<void>(
            key: ValueKey('mypost'),
            child: PostPage(),
          )
          else if (currentRoute.pathTemplate== '/message')
          const FadeTransitionPage<void>(
            key: ValueKey('message'),
            child: MessagePage(),
          )
          else if (currentRoute.pathTemplate == '/new/post')
          const FadeTransitionPage<void>(
            key: ValueKey('post'),
            child: CreatePostPage(),
          )
         else if (currentRoute.pathTemplate == '/edit/post/:id')
          const FadeTransitionPage<void>(
            key: ValueKey('editPost'),
            child: EditPostPage(),
          )
          else if (currentRoute.pathTemplate == '/post/:id')
          const FadeTransitionPage<void>(
            key: ValueKey('postDetail'),
            child: PostDetailPage(),
          )
          else if (currentRoute.pathTemplate == '/splash')
          const FadeTransitionPage<void>(
            key: ValueKey('Splash'),
            child: Splash(),
          )


        // Avoid building a Navigator with an empty `pages` list when the
        // RouteState is set to an unexpected path, such as /signin.
        //
        // Since RouteStateScope is an InheritedNotifier, any change to the
        // route will result in a call to this build method, even though this
        // widget isn't built when those routes are active.
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
