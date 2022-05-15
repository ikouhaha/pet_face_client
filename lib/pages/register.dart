// import 'package:flutter/material.dart';
// import 'package:pet_saver_client/common/api.dart' as api;
// import 'package:pet_saver_client/components/auth_text_field.dart';
// import 'package:pet_saver_client/common/image_field.dart';
// import 'package:pet_saver_client/components/auth_text_field.dart';
// import 'package:pet_saver_client/providers/register_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';


// class RegisterPage extends ConsumerWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   Stack bodyStack(WidgetRef ref) {
//     return Stack(
//       children: [
//         Positioned.fill(
//             child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
//                 child: Container(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const _WelcomeText(),
//                     // const _SignUpButton(),
//                   ],
//                 ))))
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: bodyStack(ref),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _onAlertWithCustomContentPressed(context,ref),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// _submit(WidgetRef ref){
//   var imageFile = ref.read(RegisterProvider).getFile();
//   var name = ref.read(RegisterProvider).petName.value;

//   api.asyncUploadImage("/detectBase64",name,imageFile);
  
// }

// // Alert custom content
// _onAlertWithCustomContentPressed(context,WidgetRef ref) {
//   Alert(
//       context: context,
//       title: "Submit",
//       content: Column(
//         children: <Widget>[
//           _PetNameInputField(),
//           ImageField(callback: (value) =>{
//             ref.read(RegisterProvider).setImage(value)
//           })
//         ],
//       ),
//       buttons: [
//         DialogButton(
//           width: 300,
//           onPressed: () => _submit(ref),
//           child: Text(
//             "Submit",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         )
//       ]).show();
// }

// class _WelcomeText extends StatelessWidget {
//   const _WelcomeText({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.only(bottom: 30.0, top: 30.0),
//       child: Text(
//         'Click button to add your pets :',
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class _PetNameInputField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, child) {
//       var petName = ref.watch(RegisterProvider).petName;
//       return AuthTextField(
//           icon: Icon(Icons.pets),
//           hint: 'Pet Name',
//           key: const Key('loginForm_emailInput_textField'),
//           keyboardType: TextInputType.emailAddress,
//           error: petName.error?.name,
//           onChanged: (email) => ref.read(RegisterProvider).setPetName(email));
//     });
//   }
// }
