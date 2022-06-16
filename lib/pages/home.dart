// ignore_for_file: avoid_print, unused_local_variable, unused_element, non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/components/home_post_card.dart';

import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/pet.dart';
import 'package:pet_saver_client/models/petDetect.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';




final _getProfileProvider =
    FutureProvider.autoDispose<List<PetModel>>((ref) async {
      var response = await Http.get(url: "/pets");
  List<PetModel> pets = petModelFromJson(json.encode(response.data));
  
  return pets;
});


class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //final _petname = FormController();
  final _name = FormController();
  final _createKeyForm = GlobalKey<FormState>();
  bool load = false;
  XFile? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    
    super.dispose();
    _createKeyForm.currentState?.dispose();
    
  }


  void loadPage() {
    //ref.refresh(_getProfileProvider);
  }

  Alert detectImageAlert() {
    PetModel pet = PetModel();
    //to do change it to form input

    List<PetDetectResponse> results = [];

    return Alert(
      context: context,
      title: "Detect loss pet",
      content: Form(
          key: _createKeyForm,
          child: Column(
            children: <Widget>[
              ImageField(
                  image: null,
                  callback: (file, setImg) async {
                    try {
                      EasyLoading.showProgress(0.3, status: 'detecting...');
                      Response response = await Http.postImage(
                          server: Config.pythonApiServer,
                          url: "/detectBase64",
                          imageFile: file);
                      pet.imageBase64 = await Helper.imageToBase64(file);
                      results = petDetectResponseFromJson(
                          json.encode(response.data["result"]));
                      print(results);
                      //todo make it to multiple, currently just support a pet a image
                      if (results.isNotEmpty) {
                        setState(() {
                          Image img = Helper.getImageByBase64orHttp(
                              results[0].labelImg!);
                          setImg(img);
                        });
                      }
                      Navigator.of(context, rootNavigator: true).pop();
                    } catch (e) {

                      print(e);
                    } finally {
                      EasyLoading.dismiss();
                    }

                    //ref.read(RegisterProvider).setImage(value)
                  })
            ],
          )),
      buttons: []
    );
  }

  Alert createAlert() {
    PetModel pet = PetModel();
    //to do change it to form input

    List<PetDetectResponse> results = [];
    return Alert(
        context: context,
        title: "Find",
        padding:EdgeInsets.zero ,
        content: Form(
            key: _createKeyForm,
            child: Column(
              children: <Widget>[
                
                _typeField(),
               _postTypeField(),
                _BreedsField(),
                _RegionField(),
                 _descriptionField(),
              ],
            )),
        buttons: [
        
          DialogButton(
            color: Colors.transparent,
            onPressed: ()  {
             
            },
            child: const Text(
              "Reset",
              style: TextStyle(fontSize: 20),
            ),
          ),
            DialogButton(
            onPressed: () async {
              try {
                if (_createKeyForm.currentState!.validate()) {
                  pet.name = _name.ct.text;
                  pet.about = "about";
                  pet.breedId = 1;
                  EasyLoading.showProgress(0.3, status: 'creating...');
                  pet.cropImgBase64 = results[0].cropImgs![0];
                  pet.type = results[0].name;

                  Navigator.of(context, rootNavigator: true).pop();
                  await EasyLoading.showSuccess("create success");

                  loadPage();
                }

                //todo make it to multiple, currently just support a pet a image

              } catch (e) {
                EasyLoading.showError(e.toString());
              } finally {
                EasyLoading.dismiss();
              }
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        
        
        ]);
  }


  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(_getProfileProvider);
    
    //return Text('data');
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemWidth = size.width / 2;
    return provider.when(
        loading: () {
          
          return Center(
              child: CircularProgressIndicator(),
            );
        },
        error: (dynamic err, stack) {
          if (err.message == 401) {
            FirebaseAuth.instance.signOut();
            RouteStateScope.of(context).go("/signin");
            
          }

          return Text("Error: ${err}");
        },
        data: (profiles) {
          return Scaffold(
            body: MasonryGridView.count(
              addAutomaticKeepAlives: true,
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return PostCard(profile: profiles[index]);
              },
            ),
            floatingActionButton: _createButton(),
          );
        });
  }

  Widget _PetNameInputField() {
    return AuthTextField(
        isRequiredField: false,
        controller: _name.ct,
        icon: const Icon(Icons.pets),
        hint: 'Pet Name',
        key: const Key('name'),
        keyboardType: TextInputType.text);
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


  Widget _NameField() {
    return AuthTextField(
        isRequiredField: false,
        key: const Key('email'),
        focusNode: _name.fn,
        icon: const Icon(Icons.pets),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        controller: _name.ct,
        hint: 'Post Name',
        keyboardType: TextInputType.text,
        validator: (value) => Validations.validateName(value));
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


  Widget _foundTypeField() {
    return AuthRadioField(
        isRequiredField: false,
        key: const Key('found_type'),
        //controller: _role.ct,
        type: RadioWidget.row,
        options: [
          Option(name: "Found", value: "found"),
          Option(name: "Adopt", value: "adopt")
        ],
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Type',
        onChanged: (value) => setState(() {
              // _role.ct.text = value;
            }));
  }

  Widget _typeField() {
    return AuthRadioField(
        isRequiredField: false,
        key: const Key('pet_type'),
        //controller: _role.ct,
        type: RadioWidget.row,
        options: [
          Option(name: "Cat", value: "cat"),
          Option(name: "Dog", value: "dog")
        ],
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Pet',
        onChanged: (value) => setState(() {
              // _role.ct.text = value;
            }));
  }
  

  Widget _BreedsField() {
    return AuthDropDownField(
        isRequiredField: false,
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

  Widget _RegionField() {
    return AuthDropDownField(
        isRequiredField: false,
        key: const Key('region'),
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hint: 'Region',
        //validator: (value) => Validations.validateName(value),
        options: [
          Option(name: "Hong Kong Island", value: "hkl"),
          Option(name: "Kowloon", value: "kowloon")
        ]);
  }

  Widget _createButton() {
    return SpeedDial(
        icon: Icons.search,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            foregroundColor: Colors.white,
            child: const Icon(Icons.list),
            label: 'filters',
            backgroundColor: Colors.blue,
            onTap: () {
              createAlert().show();
            },
          ),
          SpeedDialChild(
            foregroundColor: Colors.white,
            child: const Icon(Icons.filter),
            label: 'Detect loss pet',
            backgroundColor: Colors.blue,
            onTap: () {
              detectImageAlert().show();
            },
          )
        ]);
  }
}
