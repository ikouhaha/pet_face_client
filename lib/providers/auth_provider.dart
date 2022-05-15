
import 'package:pet_saver_client/components/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationProvider = Provider<Authentication>((ref) {
  return Authentication();
});


final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  
  return ref
      .watch(authenticationProvider)
      .authStateChange;
});