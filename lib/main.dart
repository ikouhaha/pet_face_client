
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/pages/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    var value = newValue.toString();
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$value"
}''');
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesService.sharedPrefs  = await SharedPreferences.getInstance();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),

  ));
  await remoteConfig.fetchAndActivate();

  
  Config.apiServer = remoteConfig.getString('apiServer');
  Config.pythonApiServer = remoteConfig.getString('pythonApiServer');
  Config.googleClientId = remoteConfig.getString('googleClientId');
  Config.firebaseRDBUrl = remoteConfig.getString('firebaseRDBUrl');
  //await Helper.refreshToken();
  runApp(
     ProviderScope(observers: [Logger()], child:  App())
  );
  //runApp(const );
}
