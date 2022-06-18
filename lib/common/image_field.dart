import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/validations.dart';

class ImageField extends StatefulWidget {
  final Image? image;
  ImagePicker picker = ImagePicker();
  final bool isRequiredField;
  final void Function(XFile, Function) callback;
  FormFieldValidator<String?>? validator;
  final String? error;

  ImageField(
      {Key? key,
      required this.callback,
      this.image,
      this.validator,
      this.isRequiredField = true,
      this.error = null})
      : super(key: key);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState();
}

class ImageFromGalleryExState extends State<ImageField> {
  var _image;
  var imagePicker;

  ImageFromGalleryExState();

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      _image = widget.image;
    }
    imagePicker = new ImagePicker();
  }

  Image getImg(String path) {
    return kIsWeb ? Image.network(path) : Image.file(File(path));
  }

  void setImg(Image img) {
    setState(() {
      _image = img;
    });
  }

  // List<Widget> getImageWidgets() {
  //   var widgets = <Widget>[];
  //   widgets.add(Center(
  //     child: GestureDetector(
  //       onTap: () async {
  //         var source = ImageSource.gallery;

  //         XFile image = await imagePicker.pickImage(
  //             source: source,
  //             imageQuality: 50,
  //             preferredCameraDevice: CameraDevice.front);
  //         setState(() {
  //           //_image = getImg(image.path);
  //           widget.callback(image, setImg);
  //         });
  //       },
  //       child: Container(
  //         width: 224,
  //         height: 224,
  //         decoration: BoxDecoration(color: Colors.grey[200]),
  //         child: _image != null
  //             ? _image
  //             : Container(
  //                 decoration: BoxDecoration(color: Colors.grey[200]),
  //                 width: 224,
  //                 height: 224,
  //                 child: Icon(
  //                   Icons.camera_alt,
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //       ),
  //     ),
  //   ));

  //   if (widget.error != null && widget.error!.isNotEmpty) {
  //     widgets.add(
  //       Text(
  //         widget.error!,
  //         style: TextStyle(color: Colors.red),
  //       ),
  //     );
  //   }

  //   return widgets;
  // }

  @override
  Widget build(BuildContext context) {
    return ImageFormField(
      image: _image,
      callback: widget.callback,
      validator: (value) {
        if (widget.validator != null) {
          String? result = widget.validator!(value);
          // if(result!=null&&focusNode!=null){
          //   //focusNode!.requestFocus();
          // }
          //return validator!(value);
          return result;
        }

        return null;
      },
      onTab: () async {
        var source = ImageSource.gallery;

        XFile image = await imagePicker.pickImage(
            source: source,
            imageQuality: 50,
            preferredCameraDevice: CameraDevice.front);
        setState(() {
          //_image = getImg(image.path);
          widget.callback(image, setImg);
        });
      },
      isRequiredField: widget.isRequiredField,
      error: widget.error,
    );
  }
}

class ImageFormField extends FormField<String> {
  final Image? image;
  ImagePicker picker = ImagePicker();
  final bool isRequiredField;
  final void Function(XFile, Function) callback;
  final void Function() onTab;
  FormFieldValidator<String?>? validator;
  FormFieldSetter<String>? onSaved;
  final String? error;

  ImageFormField({
    this.onSaved,
    this.validator,
    required this.callback,
    required this.onTab,
    this.image,
    this.isRequiredField = true,
    this.error = null,
    String initialValue = "",
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<String> state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: onTab,
                      child: Container(
                        width: 224,
                        height: 224,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: image ??
                            Container(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              width: 224,
                              height: 224,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                      ),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText??"",
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                ],
              );
            });
}
