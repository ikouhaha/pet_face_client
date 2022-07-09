
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/components/Authentication.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

import '../mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('load auth signInWithEmailAndPassword', (tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    EmailAuthCredential mockCredential = EmailAuthProvider.credential(
      email: 'test',
      password: 'test',
    ) as EmailAuthCredential;

    await tester.pumpWidget(createWidgetForTesting(child: Splash()));
    Authentication mockAuth = Authentication();
    when(mockAuth.signInWithEmailAndPassword("", ""))
        .thenAnswer((realInvocation) => Future.value(mockCredential));

    await mockAuth.signInWithEmailAndPassword(
        "ikouhaha888@gmail.com", "password");

    await tester.pumpAndSettle();
  });

  testWidgets('load auth signUpWithEmailAndPassword', (tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    EmailAuthCredential mockCredential = EmailAuthProvider.credential(
      email: 'test',
      password: 'test',
    ) as EmailAuthCredential;

    await tester.pumpWidget(createWidgetForTesting(child: Splash()));
    Authentication mockAuth = Authentication();
    when(mockAuth.signUpWithEmailAndPassword("", ""))
        .thenAnswer((realInvocation) => Future.value(mockCredential));

    await mockAuth.signUpWithEmailAndPassword(
        "ikouhaha888@gmail.com", "password");

    await tester.pumpAndSettle();
  });

  testWidgets('load auth signInWithGoogle', (tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    EmailAuthCredential mockCredential = EmailAuthProvider.credential(
      email: 'test',
      password: 'test',
    ) as EmailAuthCredential;

    await tester.pumpWidget(createWidgetForTesting(child: Container()));
    Authentication mockAuth = Authentication();
    final BuildContext context = tester.element(find.byType(Container));
    when(mockAuth.signInWithGoogle(context))
        .thenAnswer((realInvocation) => Future.value(mockCredential));

    await mockAuth.signInWithGoogle(context);

    await tester.pumpAndSettle();
  });


  testWidgets('load auth signout', (tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    EmailAuthCredential mockCredential = EmailAuthProvider.credential(
      email: 'test',
      password: 'test',
    ) as EmailAuthCredential;

    await tester.pumpWidget(createWidgetForTesting(child: Container()));
    Authentication mockAuth = Authentication();
    // final BuildContext context = tester.element(find.byType(Container));
    when(mockAuth.signOut())
        .thenAnswer((realInvocation) => Future.value(mockCredential));

    await mockAuth.signOut();

    await tester.pumpAndSettle();
  });
}
