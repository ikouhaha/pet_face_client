// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/pages/editPost.dart';
import 'package:pet_saver_client/pages/mypost.dart';
import 'package:pet_saver_client/pages/notifications.dart';
import 'package:pet_saver_client/pages/postDetail.dart';

import 'package:pet_saver_client/pages/signup_scaffold.dart';
import 'package:pet_saver_client/router/route_state.dart';

import '../widgets/fade_transition_page.dart';

import 'signin_scaffold.dart';
import 'scaffold.dart';

/// Builds the top-level navigator for the app. The pages to display are based
/// on the `routeState` that was parsed by the TemplateRouteParser.
class MyNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyNavigator({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  _BookstoreNavigatorState createState() => _BookstoreNavigatorState();
}

class _BookstoreNavigatorState extends State<MyNavigator> {
  final _signInKey = const ValueKey('Sign in');
  final _signUpKey = const ValueKey('Sign up');
  final _scaffoldKey = const ValueKey('App scaffold');
  final _notificationKey = const ValueKey('notification');
  final _postKey = const ValueKey('post');
  final _editKey = const ValueKey('editPost');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {

        if (route.settings is Page &&
            (route.settings as Page).key == _postKey) {
          routeState.go('/');
        }

          if (route.settings is Page &&
            (route.settings as Page).key == _editKey) {
          routeState.go('/mypost');
        }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
              key: _signInKey, child: const LoginScaffold())
        else if (routeState.route.pathTemplate == '/signup')
          // Display the sign in screen.
          FadeTransitionPage<void>(
              key: _signUpKey, child: const SignupScaffold())
        else ...[
          // Display the app
          FadeTransitionPage<void>(
            key: _scaffoldKey,
            child: MyScaffold(),
          ),
          // if (pathTemplate == '/notifications')
          //    MaterialPage<void>(
          //       key: _notificationKey,
          //       child: const NotificationPage()
          //     ),
           if(pathTemplate=='/post/:id')
            MaterialPage<void>(
              key: _postKey,
              child:  PostDetailPage(),
            ),
            
           if(pathTemplate=='/edit/post/:id')
            MaterialPage<void>(
              key: _editKey,
              child:  EditPostPage(),
            )
  
          // if (selectedBook != null)
          //   MaterialPage<void>(
          //     key: _bookDetailsKey,
          //     child: BookDetailsScreen(
          //       book: selectedBook,
          //     ),
          //   )
          // else if (selectedAuthor != null)
          //   MaterialPage<void>(
          //     key: _authorDetailsKey,
          //     child: AuthorDetailsScreen(
          //       author: selectedAuthor,
          //     ),
          //   ),
        ],
      ],
    );
  }
}
