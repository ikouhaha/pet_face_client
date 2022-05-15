import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_radio_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/components/home_post_card.dart';

import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/pet.dart';
import 'package:pet_saver_client/models/petDetect.dart';
import 'package:pet_saver_client/pages/petSetting.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../app.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

Future<List<PetModel>> fetchPetProfile({required ref}) async {
  var token = ref.read(GlobalProvider).token;
  var response =
      await Http.get(url: "/pets/profile", authorization: token, ref: ref);
  List<PetModel> pets = petModelFromJson(json.encode(response.data));
  return pets;
}

final _getProfileProvider =
    FutureProvider.autoDispose<List<PetModel>>((ref) async {
  return fetchPetProfile(ref: ref);
});

final StateNotifierProvider<PetSettingPageState, int> SettingPageProvider =
    StateNotifierProvider<PetSettingPageState, int>(
        (_) => PetSettingPageState());

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState {
  //final _petname = FormController();
  final _name = FormController();
  final _editKeyForm = GlobalKey<FormState>();
  final _createKeyForm = GlobalKey<FormState>();
  bool load = false;
  XFile? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  void loadPage() {
    ref.refresh(_getProfileProvider);
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
                      if (results.length > 0) {
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
                _foundTypeField(),
                _typeField(),
                _NameField(),
                _BreedsField(),
                _RegionField(),
              ],
            )),
        buttons: [
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
                  Response response = await Http.post(
                      ref: ref, url: "/pets", data: pet.toJson());

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
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  RouteState get _routeState => RouteStateScope.of(context);

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(_getProfileProvider);
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return provider.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (err, stack) => Text('Error: $err'),
        data: (profiles) {
          print(profiles);
          return Scaffold(
            body: MasonryGridView.count(
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
        icon: Icon(Icons.pets),
        hint: 'Pet Name',
        key: const Key('name'),
        keyboardType: TextInputType.text);
  }

  Widget _NameField() {
    return AuthTextField(
        isRequiredField: false,
        key: const Key('email'),
        focusNode: _name.fn,
        icon: Icon(Icons.pets),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        controller: _name.ct,
        hint: 'Name',
        keyboardType: TextInputType.text,
        validator: (value) => Validations.validateName(value));
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
        icon: Icon(Icons.list),
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
        icon: Icon(Icons.list),
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
