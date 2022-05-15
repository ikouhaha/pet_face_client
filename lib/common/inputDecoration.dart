import 'package:flutter/material.dart';

class InputDecorations {
  static UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.blueAccent, width: 2));

  static UnderlineInputBorder errorBorder = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.redAccent, width: 2));

  static InputDecoration input({
    String? hint,
    Icon? icon,
    bool? isRequiredField

  }){
    String _hint = hint??"";
    Icon _icon = icon??Icon(Icons.person);
    bool _isRequiredField = isRequiredField??true;

    return InputDecoration(
              icon: icon,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              filled: true,
              hintText: _isRequiredField ? '$_hint*' : _hint,
              border: border,
              disabledBorder: border,
              enabledBorder: border,
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,              
              floatingLabelBehavior: FloatingLabelBehavior.never,
            );
  }
}
