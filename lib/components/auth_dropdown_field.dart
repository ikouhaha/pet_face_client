import 'package:flutter/material.dart';
import 'package:pet_saver_client/models/options.dart';

class AuthDropDownField extends StatelessWidget {
  final String? initialValue;
  final String hint;
  final ValueChanged<void>? onChanged;  
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
    this.initialValue = null,
    required this.options,
    
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];
    options.forEach((Option options) {
      items.add(DropdownMenuItem(
        child: Text(options.name!),
        value: options.value,
      ));
    });

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
            items: items,
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
            }
          ),
        ));
  }
}
