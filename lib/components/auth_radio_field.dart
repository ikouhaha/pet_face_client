import 'package:flutter/material.dart';
import 'package:pet_saver_client/models/options.dart';

enum RadioWidget { column, row }

class AuthRadioField extends StatelessWidget {
  final String hint;
  final ValueChanged<dynamic> onChanged;
  final bool isRequiredField;

  final String? value;
  final RadioWidget? type;
  final Icon? icon;
  final EdgeInsets padding;
  final TextEditingController? controller;

  final List<Option> options;

  List<Widget> _buildRadioListTile() {
    
    return options
        .map((data) => 
       RadioListTile(
            title: Text("${data.name}"),
            groupValue: controller?.text,
            value: data.value,
            onChanged: onChanged))
        
        .toList();
  }

  List<Widget> _buildRowListTile() {
    return options
        .map(
          (data) => Expanded(
              
              child: RadioListTile(
                  title: Text("${data.name}"),
                  groupValue: controller?.text,
                  value: data.value,
                  onChanged: onChanged)),
        )
        .toList();
  }

  const AuthRadioField(
      {required Key key,
      required this.options,
      this.hint = '',
      this.value,
      required this.onChanged,
      this.isRequiredField = true,
      this.padding = const EdgeInsets.all(0),
      this.controller = null,
      this.icon = null,
      this.type = RadioWidget.column})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(this.error);
    UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.blueAccent, width: 2));
    UnderlineInputBorder errorBorder = UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.redAccent, width: 2));
    return Padding(
        padding: padding,
        child: type == RadioWidget.column
            ? Column(
                children: _buildRadioListTile(),
              )
            : Row(children: _buildRowListTile()));
  }
}
