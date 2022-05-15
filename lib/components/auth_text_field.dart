import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String? initialValue;
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final bool isRequiredField;
  final String? error;
  final bool visible;

  final EdgeInsets padding;
  final Icon? icon;
  final TextEditingController? controller;  
  final Function? validator;
  final FocusNode? focusNode;
  final int? maxLines;
  

  const AuthTextField({
    required Key key,
    this.hint = '',
    this.onChanged,
    required this.keyboardType,
    this.validator = null,
    this.visible = true,
    this.controller = null,
    this.isPasswordField = false,
    this.isRequiredField = true,
    this.error = null,
    this.focusNode = null,
    this.padding = const EdgeInsets.all(0),
    this.icon = null,
    this.initialValue = null,
    this.maxLines = 1,
    
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(this.error);
    UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.blueAccent, width: 2));
    UnderlineInputBorder errorBorder = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.redAccent, width: 2));
    return Visibility(
        visible: visible,
        child: Padding(
          padding: padding,
          child: TextFormField(     
            autovalidateMode: AutovalidateMode.onUserInteraction,    
            focusNode: focusNode,
            initialValue: initialValue,
            controller: controller,
            autofocus: false,
            keyboardType: keyboardType,
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
            autocorrect: false,
            textInputAction: TextInputAction.done,
            obscureText: isPasswordField,
            maxLines: maxLines,
            onChanged: onChanged,
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
            },
          ),
        ));
  }
}
