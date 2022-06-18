import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:pet_saver_client/models/options.dart';
enum AuthDropDownFieldType {
String,Int
}

class AuthDropDownField extends StatelessWidget {
  
  final String? value;
  final String hint;
  final ValueChanged<String>? onChanged;  
  final bool isPasswordField;
  final bool isRequiredField;
  final String? error;
  final bool visible;
  

  final EdgeInsets padding;
  final Icon? icon;
  final TextEditingController? controller;  
  final Function? validator;
  final FocusNode? focusNode;
  final List<Option> options;
  final AuthDropDownFieldType optionType;

  const AuthDropDownField({
    required Key key,
    this.hint = '',
    this.onChanged,    
    this.validator = null,
    this.visible = true,
    this.controller = null,
    this.isPasswordField = false,
    this.isRequiredField = true,
    this.error = null,
    this.focusNode = null,
    this.padding = const EdgeInsets.all(0),
    this.icon = null,
    this.value = null,
    this.optionType = AuthDropDownFieldType.String,
    required this.options,
    
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> stringItems = [];
    List<DropdownMenuItem<Int>> intItems = [];
    if( optionType==AuthDropDownFieldType.Int){
         options.forEach((Option options) {
      intItems.add(DropdownMenuItem(
        child: Text(options.name!),
        value: options.value,
      ));
    });
    }else{
    
        options.forEach((Option options) {
      stringItems.add(DropdownMenuItem(
        child: Text(options.name!),
        value: options.value.toString(),
      ));
    });

    }
   
  

    // print(this.error);
    UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.blueAccent, width: 2));
    UnderlineInputBorder errorBorder = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.redAccent, width: 2));
    return Visibility(
        visible: visible,
        child: Padding(
          padding: padding,
          child: DropdownButtonFormField( 
            value: value,    
            items: optionType==AuthDropDownFieldType.Int?intItems:stringItems,
            autovalidateMode: AutovalidateMode.onUserInteraction,    
            focusNode: focusNode,
            autofocus: false,            
            decoration: InputDecoration(
              icon: icon,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              filled: true,
              hintText: isRequiredField ? '$hint*' : hint,
              border: border,
              disabledBorder: border,
              enabledBorder: border,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              errorText: error,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            onChanged: (value){
              onChanged?.call(value.toString());
            },
            validator: (value){
              
              if(validator != null){
                String? result =  validator!(value);
                if(result!=null&&focusNode!=null){
                  //focusNode!.requestFocus();
                }
                //return validator!(value);
                return result;
              }

              return null;
            }
          ),
        ));
  }
}
