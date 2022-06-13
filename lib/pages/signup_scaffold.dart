import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/common/http-common.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';


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
  final _username = FormController();
  final _password = FormController();
  final _confirmPassword = FormController();
  final _firstName = FormController();
  final _lastName = FormController();
  final _companyCode = FormController();
  final _role = FormController();
  var _user = UserModel();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
     _email.ct.addListener(() {           
      _user = _user.copyWith(email: _email.ct.text);
    });
    _username.ct.addListener(() {      
      _user = _user.copyWith(username: _username.ct.text);
    });
     _password.ct.addListener(() {       
      _user = _user.copyWith(password: _password.ct.text);
    });
     _role.ct.addListener(() {       
      _user = _user.copyWith(role: _role.ct.text);
    });
     _firstName.ct.addListener(() {       
      _user = _user.copyWith(firstName: _firstName.ct.text);
    });
     _lastName.ct.addListener(() {       
      _user = _user.copyWith(lastName: _lastName.ct.text);
    });
    _companyCode.ct.addListener(() {      
      _user = _user.copyWith(companyCode:_companyCode.ct.text);
    });
    _role.ct.text = "user";
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
                            _UsernameInputField(),
                            _PasswordInputField(),
                            _ConfirmPasswordInputField(),
                            _firstNameField(),
                            _lastNameField(),
                            _RoleRadioField(),
                            _CompanyCodeInputField(),
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
    _username.dispose();
    _password.dispose();    
    _confirmPassword.dispose();
    _role.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _companyCode.dispose();

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
        focusNode:_email.fn,
        icon: Icon(Icons.email),
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: _email.ct,
        hint: 'Email',        
        keyboardType: TextInputType.emailAddress,
        validator: (value) => Validations.validateEmail(value));
  }

  Widget _UsernameInputField() {
    return AuthTextField(
      key: const Key('username'),
       focusNode:_username.fn,
        controller: _username.ct,
        icon: Icon(Icons.person),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Username',        
        keyboardType: TextInputType.text,
        validator: (value) => Validations.validateName(value));
  }

  Widget _PasswordInputField() {
    //print(pwd.error?.name);
    return AuthTextField(
      key: const Key('pwd'),
        focusNode:_password.fn,
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
        focusNode:_confirmPassword.fn,
        controller: _confirmPassword.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Password',
        isPasswordField: true,
        
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validations.validateConfirmPassword(_password.ct.text, value));
  }

  Widget _RoleRadioField() {
    return AuthRadioField(
      key: const Key('role'),
        controller: _role.ct,
        options: [
          Option(name: "User", value: "user"),
          Option(name: "Staff", value: "staff")
        ],
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Role',        
        onChanged: (value) => setState(() {
              _role.ct.text = value;
            }));
  }

  Widget _SignupButton() {
    Future<void> _signup() async {
      try {
        if (_keyForm.currentState!.validate()) {
          EasyLoading.show(
              maskType: EasyLoadingMaskType.black, status: 'loading...');          
          Response response = await Http.post(url: "/users", data: _user);
          EasyLoading.showSuccess('Sign up success!');
          RouteStateScope.of(context).go('/signin');
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

  Widget _CompanyCodeInputField() {    
    return AuthTextField(
      key: const Key('companyCode'),
        focusNode:_companyCode.fn,
        controller: _companyCode.ct,
        visible: _role.ct.text == "staff" ? true : false,
        icon: Icon(Icons.home),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Company Code, please fill if you are a staff',        
        
        keyboardType: TextInputType.text,
        validator:(value)=> Validations.validateText(value));      
  }
  Widget _firstNameField() {    
    return  AuthTextField(
      key: const Key('firstName'),
      focusNode:_firstName.fn,
        controller: _firstName.ct,
        icon: Icon(Icons.person),
        padding: EdgeInsets.symmetric(vertical: 10),
        hint: 'First Name',        
        
        keyboardType: TextInputType.text
        );      
  }
   Widget _lastNameField() {    
    return  AuthTextField(
      key: const Key('lastName'),
      focusNode:_lastName.fn,
        controller: _lastName.ct,
        icon: Icon(Icons.person),
        padding: EdgeInsets.symmetric(vertical: 10),
        hint: 'First Name',        
        
        keyboardType: TextInputType.text
        );      
  }

  Widget _GoogleSignInButton() {
    final _auth = ref.watch(authenticationProvider);
    Future<void> _loginWithGoogle() async {
      //loading2();
      try {
        EasyLoading.show(
            maskType: EasyLoadingMaskType.black, status: 'loading...');
        await _auth.signInWithGoogle(context).whenComplete(() => null);
        if (_auth.getGoogleUser != null) {
          var user = _auth.getGoogleUser!;
          var username = user.email.split('@')[0];
          _email.ct.text = user.email;          
          _username.ct.text = username;
          _firstName.ct.text = user.displayName!.split(' ')[0];
          _lastName.ct.text = user.displayName!.split(' ')[1];
          _user = _user.copyWith(
            googleId: user.id,
            avatarUrl: user.photoUrl
          );
          print(_user.toJson());
      
        }
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
