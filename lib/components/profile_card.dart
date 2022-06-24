// ignore_for_file: non_constant_identifier_names, duplicate_ignore, unnecessary_const

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/common/http-common.dart';

import 'package:flutter/cupertino.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';

import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/models/formController.dart';

import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/providers/auth_provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_saver_client/providers/global_provider.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileCard extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<ProfileCard> {
  final _keyForm = GlobalKey<FormState>();

  final _displayName = FormController();
  final _companyCode = FormController();
  final _role = FormController();
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    // _email.ct.addListener(() {
    //   _user = _user.copyWith(email: _email.ct.text);
    // });
    _role.ct.addListener(() {
      _user = _user.copyWith(role: _role.ct.text);
    });
    _displayName.ct.addListener(() {
      _user = _user.copyWith(displayName: _displayName.ct.text);
    });

    // _email.ct.text = _user.email ?? "";
    _displayName.ct.text = _user.displayName ?? "";
    _companyCode.ct.text = _user.companyCode ?? "";
    _role.ct.text = _user.role ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Form(
          key: _keyForm,
          child: Column(
            children: [
              ListTile(
                leading: _user.avatarUrl == null
                    ? Icon(Icons.person)
                    : Helper.getImageByBase64orHttp(_user.avatarUrl!),
                title: const Text('Profile'),
                subtitle: Text(
                  "${_user.displayName}",
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              // _EmailInputField(),
              _displayNameField(),
              _RoleRadioField(),
              _CompanyCodeInputField(),
              _GoogleSignInButton(),
              _saveButton()
              // Image.asset('assets/card-sample-image.jpg'),
              // Image.asset('assets/card-sample-image-2.jpg'),
            ],
          )),
    );
  }

  // ignore: non_constant_identifier_names
  // Widget _EmailInputField() {
  //   return AuthTextField(
  //       key: const Key('email'),
  //       focusNode: _email.fn,
  //       icon: const Icon(Icons.email),
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //       controller: _email.ct,
  //       hint: 'Email',
  //       keyboardType: TextInputType.emailAddress,
  //       validator: (value) => Validations.validateEmail(value));
  // }

  Widget _RoleRadioField() {
    return AuthRadioField(
        key: const Key('role'),
        controller: _role.ct,
        options: [
          Option(name: "User", value: "user"),
          Option(name: "Staff", value: "staff")
        ],
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Role',
        onChanged: (value) => setState(() {
              _role.ct.text = value;
            }));
  }

  Widget _CompanyCodeInputField() {
    return AuthTextField(
        key: const Key('companyCode'),
        focusNode: _companyCode.fn,
        controller: _companyCode.ct,
        visible: _role.ct.text == "staff" ? true : false,
        icon: const Icon(Icons.home),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Company Code, please fill if you are a staff',
        keyboardType: TextInputType.text,
        validator: (value) => Validations.validateText(value));
  }

  Widget _displayNameField() {
    return AuthTextField(
        key: const Key('Name'),
        focusNode: _displayName.fn,
        controller: _displayName.ct,
        icon: const Icon(Icons.person),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Display Name',
        keyboardType: TextInputType.text);
  }

  Widget _saveButton() {
    Future<void> _update() async {
      try {
        if (_keyForm.currentState!.validate()) {
          EasyLoading.show(
              maskType: EasyLoadingMaskType.black, status: 'loading...');
          Response response =
              await Http.put(url: "/users/" + _user.id.toString(), data: _user);

          response = await Http.get(url: "/users/profile");
          UserModel userModel = UserModel.fromJson(response.data);
          SharedPreferencesService.saveProfile(userModel);

          EasyLoading.showSuccess('update successfully!');
        }
      } catch (ex) {
        EasyLoading.showError(ex.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }

    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        // ignore: deprecated_member_use
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: _update,
          child: const Text('Save'),
        )
      ],
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
          EasyLoading.showSuccess('update successfully!');
        }
      } finally {
        EasyLoading.dismiss();
      }
    }

    return Padding(
        padding: const EdgeInsets.only(top: 1),
        child: CupertinoButton(
          onPressed: _loginWithGoogle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              //  A google icon here
              //  an External Package used here
              //  Font_awesome_flutter package used
              FaIcon(FontAwesomeIcons.google),
              Text(
                ' Connect with Google',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    // _email.dispose();
    _role.dispose();
    _displayName.dispose();
    _companyCode.dispose();
  }
}
      
    
    // print(this.error);

  
