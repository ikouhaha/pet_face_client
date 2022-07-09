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
import 'package:pet_saver_client/components/post_card.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/options.dart';
import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/models/petDetect.dart';

import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _getDataProvider =
    FutureProvider.autoDispose<List<PostModel>>((ref) async {
  var response = await Http.get(url: "/posts/me");
  List<PostModel> posts = PostModelFromJson(json.encode(response.data));

  return posts;
});

class PostPage extends ConsumerStatefulWidget {
  User? user;
  PostPage({Key? key, this.user}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<PostPage> {
  //final _petname = FormController();
  final _name = FormController();
  final _editKeyForm = GlobalKey<FormState>();
  final _createKeyForm = GlobalKey<FormState>();
  String key = UniqueKey().toString();
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
    ref.refresh(_getDataProvider);
  }

  showConfirmDelete(PostModel post) {
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
                        await Http.delete(
                          server: Config.pythonApiServer,
                          url: "/image/${post.imageFilename}",
                        );
                        await Http.delete(url: "/posts/${post.id}");
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

  User? get user => widget.user ?? FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      RouteStateScope.of(context).go("/signin");
      return Container();
    }
    var provider = ref.watch(_getDataProvider);
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return provider.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (dynamic err, stack) {
          if (err.message == 401) {
            FirebaseAuth.instance.signOut();
            RouteStateScope.of(context).go("/");
          }

          return Text("Error: ${err}");
        },
        data: (posts) {
          // print(posts);
          if (Config.isTest) {
            Future.delayed(Duration(seconds: 5), () {
              showConfirmDelete(posts[0]);
            });
          }

          return Scaffold(
              body: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                  profile: posts[index],
                  editCallback: (post) {
                    RouteStateScope.of(context).go("/edit/post/${post.id}");
                  },
                  deleteCallback: (post) {
                    showConfirmDelete(post);
                  });
            },
          ));
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
