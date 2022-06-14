// ignore_for_file: non_constant_identifier_names, avoid_print, file_names, unused_local_variable, unused_import

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/image_field.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_dropdown_field.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/components/pet_card.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/pet.dart';
import 'package:pet_saver_client/models/petDetect.dart';

import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<List<PetModel>> fetchPetProfile(
    {required  ref}) async {
  var token = ref.read(GlobalProvider).token;
  var response =
      await Http.get(url: "/pets");
  List<PetModel> pets = petModelFromJson(json.encode(response.data));
  return pets;
}

final _getProfileProvider =
    FutureProvider.autoDispose<List<PetModel>>((ref) async {
  return fetchPetProfile(ref: ref);
});


class PostPage extends ConsumerStatefulWidget {
  const PostPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState {
  //final _petname = FormController();
  final _name = FormController();
  final _editKeyForm = GlobalKey<FormState>();
  final _createKeyForm = GlobalKey<FormState>();
  bool load = false;
  XFile? file;

  @override
  void initState() {
    super.initState();
      if(FirebaseAuth.instance.currentUser==null){
      Navigator.of(context).pushNamed('/login');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }
  @override
  didChangeDependencies(){
    super.didChangeDependencies();

 
    
  }
  void loadPage() {
    ref.refresh(_getProfileProvider);
  }
  Alert editAlert(PetModel pet) {
    _name.ct.text = pet.name!;
    List<PetDetectResponse> results = [];

    return Alert(
        context: context,
        title: "Submit",
        content: Form(
            key: _editKeyForm,
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
                      } catch (e) {
                        print(e);
                      } finally {
                        EasyLoading.dismiss();
                      }

                      //ref.read(RegisterProvider).setImage(value)
                    }),
                _NameField(),
                _BreedsField(),
              ],
            )),
        buttons: [
          DialogButton(
            width: 300,
            onPressed: () async {
              try {
                if (_editKeyForm.currentState!.validate()) {
                  EasyLoading.showProgress(0.3, status: 'updating...');
                  pet.cropImgBase64 = results[0].cropImgs![0];
                  pet.type = results[0].name;
                  Response response = await Http.put(
                       url: "/pets/${pet.id}", data: pet.toJson());

                  EasyLoading.showSuccess("update success");
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
          )
        ]);
  }

  Alert createAlert() {
    PetModel pet = PetModel();
    //to do change it to form input

    List<PetDetectResponse> results = [];

    return Alert(
        context: context,
        title: "Submit",
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
                        
                      } catch (e) {
                        print(e);
                      } finally {
                        EasyLoading.dismiss();
                      }

                      //ref.read(RegisterProvider).setImage(value)
                    }),
                _NameField(),
                _BreedsField(),
              ],
            )),
        buttons: [
          DialogButton(
            width: 300,
            onPressed: () async {
              try {
                if (_createKeyForm.currentState!.validate()) {
                  pet.name = _name.ct.text;
                  pet.about = "about";
                  pet.breedId = 1;
                  EasyLoading.showProgress(0.3, status: 'creating...');
                  pet.cropImgBase64 = results[0].cropImgs![0];
                  pet.type = results[0].name;
                  Response response = await Http.post(url: "/pets", data: pet.toJson());

                 
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
          )
        ]);
  }

  showConfirmDelete(PetModel pet) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Delete'),
              content: const Text("Are you sure you want to delete this pet?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      try {
                         Navigator.of(ctx).pop(false);
                        EasyLoading.showProgress(0.3, status: 'deleting...');
                        Response response =
                            await Http.delete(url: "/pets/${pet.id}");
                        EasyLoading.showSuccess("delete success");
                        loadPage();
                       
                      } catch (e) {
                        EasyLoading.showError(e.toString());
                      } finally {
                        EasyLoading.dismiss();
                      }
                    },
                    child: const Text("Yes"))
              ],
            ));
  }


  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(_getProfileProvider);
    var size = MediaQuery.of(context).size;
    
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return provider.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
       error: (dynamic err, stack) {
          if (err.message == "Unauthorized") {
            ref.read(GlobalProvider).logout();
            RouteStateScope.of(context).go("/signin");
          }

          return Text("Error: ${err}");
        },
        data: (profiles) {
          print(profiles);
          return Scaffold(
            body: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                 return PetCard(
                    profile: profiles[index],
                    editCallback: (profile) {
                      print(profile);
                      editAlert(profile).show();
                    },
                    deleteCallback: (profile) {
                      showConfirmDelete(profile);
                    });
              },
            )
          );
        });
  }


  Widget _NameField() {
    return AuthTextField(
        key: const Key('email'),
        focusNode: _name.fn,
        icon: const Icon(Icons.pets),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        controller: _name.ct,
        hint: 'Name',
        keyboardType: TextInputType.text,
        validator: (value) => Validations.validateName(value));
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

 

}
