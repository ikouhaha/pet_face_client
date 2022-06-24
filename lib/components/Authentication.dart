import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';


class Authentication {
  // For Authentication related functions you need an instance of FirebaseAuth
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _googleToken ;
  String? _facebookToken ;
  GoogleSignInAccount? _googleUser ;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  String? get getAccessToken => this._googleToken;
  GoogleSignInAccount? get getGoogleUser => this._googleUser;
  //  SigIn the user using Email and Password
  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
   
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    
  }

  // SignUp the user using Email and Password
  Future<void> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      // await showDialog(
      //     context: context,
      //     builder: (ctx) => AlertDialog(
      //             title: Text('Error Occured'),
      //             content: Text(e.toString()),
      //             actions: [
      //               TextButton(
      //                   onPressed: () {
      //                     Navigator.of(ctx).pop();
      //                   },
      //                   child: Text("OK"))
      //             ]));
    } catch (e) {
      if (e == 'email-already-in-use') {
        print('Email already in use.');
      } else {
        print('Error: $e');
      }
    }
  }

  //  SignIn the user Google
  Future<void> signInWithGoogle(BuildContext context) async {
    
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: Config.googleClientId,
      scopes: [
        'email',
        'profile',
      ],
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    _googleToken = googleAuth.accessToken;
    _googleUser = googleUser;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // await showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: Text('Error Occured'),
      //     content: Text(e.toString()),
      //     actions: [
      //       TextButton(
      //           onPressed: () {
      //             Navigator.of(ctx).pop();
      //           },
      //           child: Text("OK"))
      //     ],
      //   ),
      // );
    } finally {
      
    }
  }

  //  SignOut the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
