import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/inputDecoration.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/formz/email.dart';
import 'package:pet_saver_client/formz/name.dart';
import 'package:pet_saver_client/formz/password.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/providers/auth_provider.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'dart:convert';

// Future<dynamic> signIn({required ref}) async {
//   String auth = 'Basic ' +
//       base64Encode(utf8.encode('${username.value}:${password.value}'));
//   Response response =
//       await Http.post(url: "/auth", authorization: auth, ref: ref);
//   return response.data;
// }

class LoginScaffold extends ConsumerStatefulWidget {
  const LoginScaffold({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _LoginFormState();
  }
}

class _LoginFormState extends ConsumerState<LoginScaffold> {
  final _keyForm = GlobalKey<FormState>();
  final _password = FormController();
  final _emailName = FormController();  
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailName.dispose();
    _password.dispose();
  }

  Future<void> _loginWithGoogle() async {
    //loading2();
    final _auth = ref.watch(authenticationProvider);
    try {
      EasyLoading.show(
          maskType: EasyLoadingMaskType.black, status: 'loading...');
      await _auth.signInWithGoogle(context).whenComplete(() => null);
      String? token = await  FirebaseAuth.instance.currentUser?.getIdToken(true);
      var response = await Http.get(url: "/users/profile",authorization: token);
      UserModel userModel = UserModel.fromJson(response.data);
      SharedPreferencesService.saveProfile(userModel);
      // String token = _auth.getAccessToken == null ? "" : _auth.getAccessToken!;       
      RouteStateScope.of(context).go("/");
    } catch (ex) {
      EasyLoading.showError(ex.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _login() async {
    final _auth = ref.watch(authenticationProvider);
    try {
      if (_keyForm.currentState!.validate()) {
        EasyLoading.show(
            maskType: EasyLoadingMaskType.black, status: 'loading...');
       await _auth.signInWithEmailAndPassword(_emailName.ct.text,_password.ct.text).whenComplete(() => null);
           String? token = await  FirebaseAuth.instance.currentUser?.getIdToken(true);
      var response = await Http.get(url: "/users/profile",authorization: token);
      UserModel userModel = UserModel.fromJson(response.data);
      SharedPreferencesService.saveProfile(userModel);
      // String token = _auth.getAccessToken == null ? "" : _auth.getAccessToken!;       
      RouteStateScope.of(context).go("/");
        // RouteStateScope.of(context).go("/");
      }
    } catch (ex) {
      EasyLoading.showError(ex.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Login'),
          leading: GestureDetector(
            onTap: () {
              ref.read(GlobalProvider).setAuthenticated();
              RouteStateScope.of(context).go("/");
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        body: SafeArea(
            child: Stack(children: [
          Positioned.fill(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
                  child: Form(
                      key: _keyForm,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _WelcomeText(),
                          _EmailInputField(),
                          //_PasswordInputField(),
                          _PasswordInputField(),
                          _LoginButton(),
                          _GoogleLoginButton(),
                          _RegisterText(),
                          // const _SignUpButton(),
                        ],
                      )))))
        ])));
  }

  Widget _WelcomeText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30.0, top: 30.0),
      child: Text(
        'Welcome to Pet Saver!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _EmailInputField() {
    return AuthTextField(
        focusNode: _emailName.fn,
        controller: _emailName.ct,
        icon: Icon(Icons.email),
        padding: const EdgeInsets.symmetric(vertical: 20),
        hint: 'Email',
        key: const Key('loginForm_emailInput_textField'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => Validations.validateEmail(value));
  }
  Widget _LoginButton() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('Login'),
            disabledColor: Colors.blueAccent.withOpacity(0.6),
            color: Colors.blueAccent,
            onPressed: _login));
  }

  Widget _PasswordInputField() {
    //print(pwd.error?.name);
    return AuthTextField(
        focusNode: _password.fn,
        controller: _password.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 20),
        hint: 'Password',
        isPasswordField: true,
        key: const Key('loginForm_passwordInput_textField'),
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => Validations.validatePassword(value));
  }

  Widget _GoogleLoginButton() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: CupertinoButton(
          onPressed: _loginWithGoogle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.google),
              Text(
                ' Login with Google',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }

  Widget _RegisterText() {
    return Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: RichText(
            text: TextSpan(
                text: "Don't have an account?",
                style: TextStyle(color: Colors.black),
                children: [
              TextSpan(
                  text: 'Sign up now',
                  style: TextStyle(color: Colors.blue.shade700),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      RouteStateScope.of(context).go("/signup");                      
                    })
            ])));
  }
}
