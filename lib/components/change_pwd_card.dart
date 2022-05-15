import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/common/http-common.dart';




import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/models/formController.dart';

import 'package:pet_saver_client/models/user.dart';


import 'package:pet_saver_client/providers/global_provider.dart';


import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangePwdCard extends ConsumerStatefulWidget {
  final UserModel user;
  const ChangePwdCard({Key? key, required this.user}) : super(key: key);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends ConsumerState<ChangePwdCard> {
  final _keyForm = GlobalKey<FormState>();
  final _password = FormController();
  final _confirmPassword = FormController();

  late UserModel _user;

  @override
  void initState() {
    super.initState();
    this._user = widget.user;

      _password.ct.addListener(() {       
      _user = _user.copyWith(password: _password.ct.text);
    });
  }

  Image getProfileImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl);
    } else {
      var bytesImage = Base64Decoder().convert(imageUrl);

      return Image.memory(bytesImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child:Form(key:_keyForm, child: Column(
        children: [
          ListTile(
            leading: getProfileImage(_user.avatarUrl!),
            title: const Text('Change Password'),
            subtitle: Text(
              "${_user.firstName} ${_user.lastName}",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          _PasswordInputField(),
          _ConfirmPasswordInputField(),
          _saveButton()
          // Image.asset('assets/card-sample-image.jpg'),
          // Image.asset('assets/card-sample-image-2.jpg'),
        ],
      )),
    );


    
  }

    Widget _PasswordInputField() {
    //print(pwd.error?.name);
    return AuthTextField(
      key: const Key('pwd'),
        focusNode:_password.fn,
        controller: _password.ct,
        icon: Icon(Icons.password_sharp),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Password',
        isPasswordField: true,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) =>
            Validations.validateConfirmPassword(_password.ct.text, value));
  }

    Widget _saveButton() {
     Future<void> _update() async {
      try {
        if (_keyForm.currentState!.validate()) {
          EasyLoading.show(
              maskType: EasyLoadingMaskType.black, status: 'loading...');     
              var token = ref.read(GlobalProvider).token;     
          Response response = await Http.put(url: "/users/p/"+_user.id.toString(), data: {
            "password": _user.password,
          }, ref: ref,authorization: await token);
          EasyLoading.showSuccess('update successfully!');
          
        }
      } catch (ex) {
        EasyLoading.showError(ex.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }

    return  ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFF6200EE),
                onPressed: _update,
                child: const Text('Save'),
              )
            ],
          );
  }


  


  
  @override
  void dispose() {
    super.dispose();
    _password.dispose();
    _confirmPassword.dispose();
  }
}
      
    
    // print(this.error);

  
