import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_saver_client/pages/navigator.dart';
import 'package:pet_saver_client/router/delegate.dart';
import 'package:pet_saver_client/router/parsed_route.dart';
import 'package:pet_saver_client/router/parser.dart';
import 'package:pet_saver_client/router/route_state.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _BookstoreState createState() => _BookstoreState();
}

class _BookstoreState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;
  // GlobalNotifier _state = new GlobalNotifier();
  

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/',
        '/splash',
        '/notifications',
        '/signin',
        '/signup',
        '/post',
        '/settings',
        '/mypost',
        '/new/post',
        '/edit/post/:id',
        '/post/:id'
      ],
      guard: _guard,
      
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => MyNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.

    super.initState();

    // _handleAuthStateChanged(status);
  }

  @override
  Widget build(BuildContext context) {
    // _state = ref.watch(GlobalProvider);    
    // _handleAuthStateChanged();
    return RouteStateScope(
      notifier: _routeState,
      child:  MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder:EasyLoading.init() ,
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeParser,
        // Revert back to pre-Flutter-2.5 transition behavior:
        // https://github.com/flutter/flutter/issues/82053
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    
    // final registerRoute = ParsedRoute('/settings/register', '/settings/register', {}, {});
    // final signInRoute = ParsedRoute('/signin', '/signin', {}, {});
    // final signUpRoute = ParsedRoute('/signup', '/signup', {}, {});
    
    
    
    // if(_state.isLogin){
    //   // if(!_state.isRegister && from == registerRoute){
    //   //   return registerRoute;
    //   // }else
    //    if(from == signInRoute) {
    //     return ParsedRoute('/', '/', {}, {});
    //   }

    // }else if(from != signInRoute && from != signUpRoute){
      
    //     return signInRoute;
    // }

    return from;
  }

  // void _handleAuthStateChanged() async{
  //   if(_state.isLogin){
  //     // if(!_state.isRegister){
  //     //   _routeState.go('/settings/register');
  //     // }else{
  //       _routeState.go('/');
  //     // }
  //   }else{
  //     _routeState.go('/signin');
  //   }
  // }

  @override
  void dispose() {
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
