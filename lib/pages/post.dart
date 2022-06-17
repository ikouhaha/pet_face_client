// ignore_for_file: unused_import, avoid_print, non_constant_identifier_names, unused_element

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/pet.dart';
import 'package:pet_saver_client/models/petDetect.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({
    Key? key,
  }) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<CreatePostPage> {
  String key = UniqueKey().toString();
  PetModel pet = PetModel();
  final _keyForm = GlobalKey<FormState>();

  List<PetDetectResponse> results = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _keyForm.currentState?.dispose();
  }

  // void _handleBookTapped(Book book) {
  //   _routeState.go('/book/${book.id}');
  // }

  @override
  Widget build(BuildContext context) {
     if (FirebaseAuth.instance.currentUser == null) {
      RouteStateScope.of(context).go("/signin");
      return Container();
    }
    //return const Center(child: Text("asdsd"));
    return Scaffold(
        body: Stack(children: [
          Positioned.fill(
              child: Card(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(1, 0, 1, 8.0),
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Form(
                              key: _keyForm,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _petTypeField(),
                                   
                                  _postTypeField(),
                                  _BreedsField(),
                                  _imageField(),
                                  _descriptionField(),
                                  _submitButton(),
                                  // const _SignUpButton(),
                                ],
                              ))))))
        ]),
      );
    }
  
  

  Widget _imageField() {
    return ImageField(
        image: null,
        callback: (file, setImg) async {
          try {
            EasyLoading.showProgress(0.3, status: 'detecting...');
            Response response = await Http.postImage(
                server: Config.pythonApiServer,
                url: "/detectBase64",
                imageFile: file,
                name: key
                );
            pet.imageBase64 = await Helper.imageToBase64(file);
            results =
                petDetectResponseFromJson(json.encode(response.data["result"]));
            print(results);
            //todo make it to multiple, currently just support a pet a image
            if (results.isNotEmpty) {
              setState(() {
                Image img = Helper.getImageByBase64orHttp(results[0].labelImg!);
                setImg(img);
              });
            }
          } catch (e) {
            print(e);
          } finally {
            EasyLoading.dismiss();
          }

          //ref.read(RegisterProvider).setImage(value)
        });
  }

  Widget _postTypeField() {
    return AuthDropDownField(
        key: const Key('post type'),
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Post Type',
        //validator: (value) => Validations.validateName(value),
        options: [
          Option(name: "cat", value: "cat"),
          Option(name: "dog", value: "dog"),
          Option(name: "dog", value: "dog")
        ]);
  }

  Widget _petTypeField() {
    return AuthRadioField(
      type: RadioWidget.row,
      key: const Key('pet type'),
      icon: const Icon(Icons.list),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      hint: 'Post Type',
      //validator: (value) => Validations.validateName(value),
      options: [
        Option(name: "cat", value: "cat"),
        Option(name: "dog", value: "dog")
      ],
      onChanged: (value) {},
    );
  }

  Widget _BreedsField() {
    return AuthDropDownField(
        key: const Key('breeds'),
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Breeds',
        //validator: (value) => Validations.validateName(value),
        options: [
          Option(name: "cat", value: "cat"),
          Option(name: "dog", value: "dog")
        ]);
  }

  Widget _descriptionField() {
    return AuthTextField(
        maxLines: 6,
        key: const Key('description'),
        icon: const Icon(Icons.comment),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        hint: 'Description',
        keyboardType: TextInputType.multiline,
        validator: (value) => Validations.validateText(value));
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_keyForm.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        },
        child: const Text('Submit'),
      ),
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        // print("------status-----");
        // print(state.status.isValidated);

        return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Logout'),
                disabledColor: Colors.blueAccent.withOpacity(0.6),
                color: Colors.redAccent,
                onPressed: () => ref.read(GlobalProvider).logout()));
      },
    );
  }
}
