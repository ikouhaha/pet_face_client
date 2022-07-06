// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:pet_saver_client/pages/splash.dart';

// void main() {

//   Widget createWidgetForTesting({required Widget child}){
//       WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();


//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   final remoteConfig = FirebaseRemoteConfig.instance;
//   await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(minutes: 1),

//   ));
//   await remoteConfig.fetchAndActivate();

  
//   Config.apiServer = remoteConfig.getString('apiServer');
//   Config.pythonApiServer = remoteConfig.getString('pythonApiServer');
//   Config.googleClientId = remoteConfig.getString('googleClientId');
//   Config.firebaseRDBUrl = remoteConfig.getString('firebaseRDBUrl');
//   //await Helper.refreshToken();
//   runApp(
//      ProviderScope(observers: [Logger()], child:  App())
//   );
// }

//   testWidgets('load splash page', (tester) async {
   
//     await tester.pumpWidget(createWidgetForTesting(child: const Splash()));

//     await tester.pumpAndSettle();
//   });
// }
