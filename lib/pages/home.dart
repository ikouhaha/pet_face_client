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
import 'package:pet_saver_client/models/findSimilarity.dart';

import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/models/petDetect.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class PostLoadingData {
  final List<Option> catBreeds;
  final List<Option> dogBreeds;
  final List<Option> districts;
  final List<PostModel> posts;

  PostLoadingData(this.catBreeds, this.dogBreeds, this.districts, this.posts);
}

class DataFilter {
  static String url = "/posts?";
  static Map<String, String> params = <String, String>{
    'page': "1",
    'limit': "1000",
  };
  static reset() {
    params.clear();
    params['page'] = "1";
    params['limit'] = "1000";
    url = "/posts?";
  }
}

final _getDataProvider =
    FutureProvider.autoDispose<PostLoadingData>((ref) async {
  List<PostModel> pets = [];

  String paramsUrl = "";
  DataFilter.params.forEach((key, value) {
    paramsUrl += "$key=$value&";
  });

  var response = await Http.get(url: DataFilter.url + paramsUrl);
  pets = PostModelFromJson(json.encode(response.data));
  response = await Http.get(url: "/options/breeds/cat");
  var catBreeds = optionsFromJson(json.encode(response.data));
  response = await Http.get(url: "/options/breeds/dog");
  var dogBreeds = optionsFromJson(json.encode(response.data));
  response = await Http.get(url: "/options/districts");
  var districts = optionsFromJson(json.encode(response.data));

  return PostLoadingData(catBreeds, dogBreeds, districts, pets);
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //final _petname = FormController();
  List<PostModel> posts = [];
  final _name = FormController();
  final _filterKeyForm = GlobalKey<FormState>();
  bool refresh = false;
  XFile? file;
  final _petType = FormController();
  final _postType = FormController();
  final _breeds = FormController();
  final _about = FormController();
  final _district = FormController();
  final _role = FormController();
  GlobalKey<_HomePageState> petTypeKey = GlobalKey();

  List<Option> dogBreeds = [];
  List<Option> catBreeds = [];
  List<Option> postTypes = [];
  List<Option> districts = [];

  @override
  void initState() {
    super.initState();
    postTypes.add(Option(value: "lost", name: "Lost"));
    postTypes.add(Option(value: "found", name: "Found"));
    postTypes.add(Option(value: "adopt", name: "Adoption"));
  }

  @override
  void dispose() {
    _name.dispose();
    DataFilter.reset();
    super.dispose();
    _filterKeyForm.currentState?.dispose();
  }

  void controllersReset() {
    _petType.ct.text = "";
    _postType.ct.text = "";
    _breeds.ct.text = "";
    _about.ct.text = "";
    _district.ct.text = "";
  }

  void loadPage() {
    ref.refresh(_getDataProvider);
  }

  Future<Null> _onRefresh() async {
    DataFilter.reset();
    String paramsUrl = "";
    DataFilter.params.forEach((key, value) {
      paramsUrl += "$key=$value&";
    });
    // loadPage();
    var response = await Http.get(url: DataFilter.url + paramsUrl);
    setState(() {
        refresh = true;
        posts = PostModelFromJson(json.encode(response.data));

    });
    
  }

  Alert detectImageAlert() {
    PostModel post = PostModel();
    //to do change it to form input

    List<PetDetectResponse> results = [];

    return Alert(
        context: context,
        title: "Detect loss pet",
        content: Form(
            key: _filterKeyForm,
            child: Column(
              children: <Widget>[
                ImageField(
                    image: null,
                    callback: (file, setImg) async {
                      try {
                        EasyLoading.showProgress(0.3, status: 'detecting...');
                        Response response = await Http.postImage(
                          server: Config.pythonApiServer,
                          url: "/detectBase64/0",
                          imageFile: file,
                          name:""
                        );
                        post.imageBase64 = await Helper.imageToBase64(file);
                        results = petDetectResponseFromJson(
                            json.encode(response.data["result"]));

                        //todo make it to multiple, currently just support a pet a image
                        if (results.isNotEmpty) {
                          setState(() {
                            Image img = Helper.getImageByBase64orHttp(
                                results[0].labelImg!);
                            setImg(img);
                          });

                          if (results[0].cropImgs != null &&
                              results[0].cropImgs!.isNotEmpty) {
                            DataFilter.reset();
                            DataFilter.params["petType"] = results[0].name!;
                            response = await Http.post(
                              server: Config.pythonApiServer,
                              url: "/findSimilarity",
                              data: {
                                "type": DataFilter.params["petType"],
                                "imageBase64": results[0].cropImgs![0],
                                
                              },
                            );

                            var findResults = findSimilarityResponseFromJson(
                                json.encode(response.data["result"]));

                            String url = "/posts/filter/inames?";
                            findResults.asMap().forEach((index, value) {
                              if (index == 0) {
                                url += "name=${value.filename}";
                              } else {
                                url += "&name=${value.filename}";
                              }
                            });
                            DataFilter.url = url;
                          }
                          loadPage();
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
        buttons: []);
  }

  void setFilterValue(String key, dynamic value) {
    if (value != null && value != "") {
      DataFilter.params[key] = value;
    }
  }

  void filterAlert() {
    PostModel post = PostModel();
    //to do change it to form input
    controllersReset();
    DataFilter.reset();
    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: Text("Title of Dialog"),
              content: Form(
                  key: _filterKeyForm,
                  child: Column(
                    children: <Widget>[
                      _petTypeField(setState),
                      _postTypeField(setState),
                      _BreedsField(setState),
                      _districtField(setState),
                      _descriptionField(setState),
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    DataFilter.reset();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      if (_filterKeyForm.currentState!.validate()) {
                        EasyLoading.showProgress(0.3, status: 'detecting...');
                        post.petType = _petType.ct.text;
                        post.type = _postType.ct.text;
                        if (_breeds.ct.text.isNotEmpty) {
                          post.breedId = int?.parse(_breeds.ct.text);
                        }
                        if (_district.ct.text.isNotEmpty) {
                          post.districtId = int?.parse(_district.ct.text);
                        }

                        post.about = _about.ct.text;

                        setFilterValue("type", post.type);
                        setFilterValue("petType", post.petType);
                        setFilterValue("about", post.about);
                        setFilterValue("districtId", post.districtId);
                        setFilterValue("breedId", post.breedId);

                        Navigator.pop(context);

                        loadPage();
                      }

                      //todo make it to multiple, currently just support a pet a image

                    } catch (e) {
                      EasyLoading.showError(e.toString());
                    } finally {
                      EasyLoading.dismiss();
                    }
                  },
                  child: Text("Search"),
                ),
              ],
            );
          },
        );
      },
    );

    List<PetDetectResponse> results = [];
    // return Alert(
    //     context: context,
    //     title: "Find",
    //     padding:EdgeInsets.zero ,
    //     content: Form(
    //         key: _filterKeyForm,
    //         child: Column(
    //           children: <Widget>[

    //             _petTypeField(),
    //            _postTypeField(),
    //             _BreedsField(),
    //             _districtField(),
    //              _descriptionField(),
    //           ],
    //         )),
    //     buttons: [

    //       DialogButton(
    //         color: Colors.transparent,
    //         onPressed: ()  {
    //             controllersReset();
    //         },
    //         child: const Text(
    //           "Reset",
    //           style: TextStyle(fontSize: 20),
    //         ),
    //       ),
    //         DialogButton(
    //         onPressed: () async {
    //           try {
    //             if (_filterKeyForm.currentState!.validate()) {
    //               EasyLoading.showProgress(0.3, status: 'detecting...');
    //               post.petType = _petType.ct.text;
    //               post.type = _postType.ct.text;
    //               if(_breeds.ct.text.isNotEmpty){
    //                 post.breedId = int?.parse(_breeds.ct.text);
    //               }
    //                if(_district.ct.text.isNotEmpty){
    //                 post.districtId = int?.parse(_district.ct.text);
    //               }

    //               post.about = _about.ct.text;

    //               setFilterValue("type", post.type);
    //               setFilterValue("petType", post.petType);
    //               setFilterValue("about", post.about);
    //               setFilterValue("districtId", post.districtId);
    //               setFilterValue("breedId", post.breedId);

    //               Navigator.of(context, rootNavigator: true).pop();

    //               loadPage();
    //             }

    //             //todo make it to multiple, currently just support a pet a image

    //           } catch (e) {
    //             EasyLoading.showError(e.toString());
    //           } finally {
    //             EasyLoading.dismiss();
    //           }
    //         },
    //         child: const Text(
    //           "Submit",
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //       ),

    //     ]);
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(_getDataProvider);

    //return Text('data');
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemWidth = size.width / 2;
    return provider.when(loading: () {
      return Center(
        child: CircularProgressIndicator(),
      );
    }, error: (dynamic err, stack) {
      if (err.message == 401) {
        FirebaseAuth.instance.signOut();
        // RouteStateScope.of(context).go("/");
        loadPage();
      } else if (err.code == "no-current-user" ||
          err.code == "user-not-found") {
        FirebaseAuth.instance.signOut();
        // RouteStateScope.of(context).go("/");
        loadPage();
      } else {
        return Text("Error: ${err}");
      }
      return Container();
    }, data: (data) {
      if(!refresh){
          posts = data.posts;
      }else{
        refresh = false;
      }
      
      dogBreeds = data.dogBreeds;
      catBreeds = data.catBreeds;
      districts = data.districts;

      return Scaffold(
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: MasonryGridView.count(
              addAutomaticKeepAlives: true,
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(profile: posts[index]);
              },
            )),
        floatingActionButton: _createButton(),
      );

      // return Scaffold(
      //   body: MasonryGridView.count(
      //     addAutomaticKeepAlives: true,
      //     crossAxisCount: 2,
      //     mainAxisSpacing: 2,
      //     crossAxisSpacing: 2,
      //     itemCount: posts.length,
      //     itemBuilder: (context, index) {
      //       return PostCard(profile: posts[index]);
      //     },
      //   ),
      //   floatingActionButton: _createButton(),
      // );
    });
  }

  Widget _descriptionField(setState) {
    return AuthTextField(
        isRequiredField: false,
        maxLines: 6,
        controller: _about.ct,
        key: const Key('description'),
        icon: const Icon(Icons.comment),
        padding: const EdgeInsets.symmetric(vertical: 16),
        hint: 'Description',
        keyboardType: TextInputType.multiline);
  }

  Widget _postTypeField(setState) {
    return AuthDropDownField(
        key: const Key('post type'),
        icon: const Icon(Icons.question_mark),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Post Type',
        options: postTypes,
        onChanged: (value) {
          setState(() {
            _postType.ct.text = value;
          });
        });
  }

  Widget _RoleRadioField(setState) {
    return AuthRadioField(
        key: const Key('role'),
        controller: _role.ct,
        options: [
          Option(name: "User", value: "user"),
          Option(name: "Staff", value: "staff")
        ],
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Role',
        onChanged: (value) => setState(() {
              _role.ct.text = value;
            }));
  }

  Widget _petTypeField(setState) {
    return AuthRadioField(
        type: RadioWidget.row,
        key: petTypeKey,
        controller: _petType.ct,
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Pet Type',
        //validator: (value) => Validations.validateName(value),
        options: [
          Option(name: "cat", value: "cat"),
          Option(name: "dog", value: "dog")
        ],
        onChanged: (value) => setState(() {
              _breeds.ct.text = "";
              _petType.ct.text = value;
            }));
  }

  Widget _BreedsField(setState) {
    if (_petType.ct.text == "cat") {
      return AuthDropDownField(
          isRequiredField: false,
          key: const Key('breedsCat'),
          icon: const Icon(Icons.list),
          padding: const EdgeInsets.symmetric(vertical: 10),
          hint: 'Breeds',
          options: catBreeds,
          value: _breeds.ct.text.isEmpty ? null : _breeds.ct.text,
          onChanged: (value) {
            setState(() {
              _breeds.ct.text = value;
            });
          });
    } else if (_petType.ct.text == "dog") {
      return AuthDropDownField(
        isRequiredField: false,
        key: const Key('breedsDog'),
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Breeds',
        options: dogBreeds,
        value: _breeds.ct.text.isEmpty ? null : _breeds.ct.text,
        onChanged: (value) {
          setState(() {
            _breeds.ct.text = value;
          });
        },
      );
    } else {
      return AuthDropDownField(
        isRequiredField: false,
        key: const Key('breedsEmpty'),
        icon: const Icon(Icons.list),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'Breeds',
        options: [],
        value: _breeds.ct.text.isEmpty ? null : _breeds.ct.text,
        onChanged: null,
      );
    }
  }

  Widget _districtField(setState) {
    return AuthDropDownField(
        isRequiredField: false,
        key: const Key('_districtField'),
        icon: const Icon(Icons.map),
        padding: const EdgeInsets.symmetric(vertical: 10),
        hint: 'District',
        //validator: (value) => Validations.validateText(value),
        options: districts,
        onChanged: (value) {
          setState(() {
            _district.ct.text = value;
          });
        });
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
              filterAlert();
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
