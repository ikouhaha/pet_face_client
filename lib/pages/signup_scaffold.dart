import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/common/http-common.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';

import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';

import 'package:pet_saver_client/models/formController.dart';

import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/providers/auth_provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_saver_client/providers/global_provider.dart';

import 'package:pet_saver_client/router/route_state.dart';
import '../models/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignupScaffold extends ConsumerStatefulWidget {
  const SignupScaffold({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState {
  final _keyForm = GlobalKey<FormState>();

  final _email = FormController();

  final _password = FormController();
  final _confirmPassword = FormController();
  var _user = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _email.ct.addListener(() {
      _user = _user.copyWith(email: _email.ct.text);
    });
    _password.ct.addListener(() {
      _user = _user.copyWith(password: _password.ct.text);
    });
    //  _role.addListener(() {
    //   _user.copyWith(role: _role.text);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Signup'),
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
            child: Stack(
          children: [
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
                            _PasswordInputField(),
                            _ConfirmPasswordInputField(),
                            _SignupButton(),
                            _GoogleSignInButton(),
                            _RegisterText(),

                            // const _SignUpButton(),
                          ],
                        )))))
          ],
        )));
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
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
        key: const Key('email'),
        focusNode: _email.fn,
        icon: Icon(Icons.email),
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: _email.ct,
        hint: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: (value) => Validations.validateEmail(value));
  }

  Widget _PasswordInputField() {
    //print(pwd.error?.name);
    return AuthTextField(
        key: const Key('pwd'),
        focusNode: _password.fn,
        controller: _password.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Password',
        isPasswordField: true,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => Validations.validatePassword(value));
  }

  Widget _ConfirmPasswordInputField() {
    //print(pwd.error?.name);
    return AuthTextField(
        key: const Key('confirmpwd'),
        focusNode: _confirmPassword.fn,
        controller: _confirmPassword.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Password',
        isPasswordField: true,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validations.validateConfirmPassword(_password.ct.text, value));
  }

  Widget _SignupButton() {
    Future<void> _signup() async {
      try {
        if (_keyForm.currentState!.validate()) {
          EasyLoading.show(
              maskType: EasyLoadingMaskType.black, status: 'loading...');
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email.ct.text, password:_password.ct.text);
            
          String? token =
              await FirebaseAuth.instance.currentUser?.getIdToken(false);
          var response =
              await Http.get(url: "/users/profile", authorization: token);
          UserModel userModel = UserModel.fromJson(response.data);
          SharedPreferencesService.saveProfile(userModel);
          // String token = _auth.getAccessToken == null ? "" : _auth.getAccessToken!;
          RouteStateScope.of(context).go("/");
        }
      } catch (ex) {
      } finally {
        EasyLoading.dismiss();
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Sign up'),
          disabledColor: Colors.blueAccent.withOpacity(0.6),
          color: Colors.blueAccent,
          onPressed: _signup),
    );
  }

  Widget _GoogleSignInButton() {
    final _auth = ref.watch(authenticationProvider);
    Future<void> _loginWithGoogle() async {
      try {
        EasyLoading.show(
            maskType: EasyLoadingMaskType.black, status: 'loading...');
        await _auth.signInWithGoogle(context).whenComplete(() => null);
        String? token =
            await FirebaseAuth.instance.currentUser?.getIdToken(true);
        var response =
            await Http.get(url: "/users/profile", authorization: token);
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

    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: CupertinoButton(
          onPressed: _loginWithGoogle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //  A google icon here
              //  an External Package used here
              //  Font_awesome_flutter package used
              FaIcon(FontAwesomeIcons.google),
              Text(
                ' Signup with Google',
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
                text: "Have an account?",
                style: TextStyle(color: Colors.black),
                children: [
              TextSpan(
                  text: 'Sign in now',
                  style: TextStyle(color: Colors.blue.shade700),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      RouteStateScope.of(context).go('/signin');
                    })
            ])));
  }
}
