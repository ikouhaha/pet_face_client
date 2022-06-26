import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/http-common.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/common/validations.dart';
import 'package:pet_saver_client/components/auth_text_field.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/providers/global_provider.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:firebase_database/firebase_database.dart';

final _getDataProvider =
    FutureProvider.autoDispose.family<PostModel, String>((ref, id) async {
  var response = await Http.get(url: "/posts/$id");
  PostModel post = PostModelObjFromJson(json.encode(response.data));

  return post;
});

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState {
  late FirebaseDatabase database;
  ScrollController _scrollController = new ScrollController();
  late DatabaseReference commentListRef;
  late String id;
  List<Comment> _commentList = [];
  bool isOwner = false;
  UserModel? profile;
  bool isInitRef = false;

  FormController comment = FormController();

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instanceFor(
        app: FirebaseDatabase.instance.app, databaseURL: Config.firebaseRDBUrl);
    profile = SharedPreferencesService.getProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    id = _routeState.route.parameters['id'].toString();
    if (!isInitRef) {
      isInitRef = true;
      commentListRef = database.ref().child("comments").child(id);
      //initCommentListRef(id);
      // commentListRef.onChildAdded.listen(_onCommentAdded);
      // commentListRef.onChildRemoved.listen(_onCommentRemoved);
      // commentListRef.onChildChanged.listen(_onCommentChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // database.goOffline();
    comment.dispose();
  }

  void initCommentListRef(id) {
    commentListRef.onValue.listen((event) {
      List<Comment> commentList = [];
      for (final child in event.snapshot.children) {
        // Handle the post.
        if (child.value != null) {
          var comment = Comment.fromJson(Helper.objectToJson(child.value!));

          if (profile?.id == comment.postOwner ||
              profile?.id == comment.commentById) {
            commentList.add(comment);
          } else if (profile?.companyCode != null) {
            if (comment.companyCode == profile?.companyCode) {
              commentList.add(comment);
            }
          }
        }
      }

      if (commentList.length > 0) {
        if (this.mounted) {
          setState(() {
            _commentList = commentList;
          });
        }
        ;
      }
    });

    // commentListRef.onChildAdded.listen((event) {
    //   // A new comment has been added, so add it to the displayed list.
    //   print(event);
    // }, onError: (error) {
    //   print(error);
    // });

    // commentListRef.onChildChanged.listen((event) {
    //   // A comment has changed; use the key to determine if we are displaying this
    //   // comment and if so displayed the changed comment.
    //   print(event);
    // });
    // commentListRef.onChildRemoved.listen((event) {
    //   // A comment has been removed; use the key to determine if we are displaying
    //   // this comment and if so remove it.
    //   print(event);
    // });
  }

  RouteState get _routeState => RouteStateScope.of(context);

  @override
  Widget build(BuildContext context) {
    // commentListRef.push().set("asdasd");

    if (FirebaseAuth.instance.currentUser == null) {
      RouteStateScope.of(context).go("/signin");
      return Container();
    }
    var pid = _routeState.route.parameters['id'];
    if (pid == null) {
      return Container();
    }

    //initCommentListRef(id);

    var provider = ref.watch(_getDataProvider(id));
    return provider.when(
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (dynamic err, stack) {
          if (err.message == 401) {
            FirebaseAuth.instance.signOut();
            RouteStateScope.of(context).go("/signin");
          }

          return Text("Error: ${err}");
        },
        data: (data) {
          if (profile!.role == "staff") {
            if (data.companyCode == profile!.companyCode) {
              isOwner = true;
            }
          } else if (profile!.role == "user") {
            if (data.createdBy == profile!.id) {
              isOwner = true;
            }
          }
          return Scaffold(
            body: Stack(children: [
              Positioned.fill(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8.0),
                      child: Card(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  PostCard(data),
                                  CommentCard(data),
                                  CommentListCard()
                                  // const _SignUpButton(),
                                ],
                              )))))
            ]),
          );
        });
  }

  Widget PostCard(PostModel post) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.person),
          title: Text(post.createdByName ?? ''),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.question_mark),
          title: Text(post.type ?? ''),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.pets),
          title: Text(post.petType ?? ''),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.lock_clock),
          title: Text(Helper.getTimeAgo(post.createdOn)),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.list),
          title: Text(post.breed ?? ''),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.location_on_rounded),
          title: Text(post.district ?? ''),
        ),
        ListTile(
          minLeadingWidth: 2,
          leading: Icon(Icons.edit),
          title: Text("Description"),
          subtitle: Text(post.about ?? ''),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: PhotoView(
            // customSize: Size(MediaQuery.of(context).size.width,150),
            imageProvider:
                NetworkImage(Config.apiServer + "/posts/image/${post.id}"),

            initialScale: PhotoViewComputedScale.contained,
          ),
        ),
      ],
    ));
  }

  Widget CommentCard(PostModel post) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Form(
            key: _keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthTextField(
                    maxLines: 4,
                    key: const Key('comment'),
                    icon: Icon(Icons.comment),
                    controller: comment.ct,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    hint: 'Comments',
                    keyboardType: TextInputType.multiline,
                    validator: (value) => Validations.validateText(value)),
                CupertinoButton(
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        Comment cm = Comment();
                        cm.avatar = profile?.avatarUrl;
                        cm.companyCode = profile?.companyCode;
                        cm.postOwner = post.createdBy;
                        cm.comment = comment.ct.text;
                        cm.commentBy = profile?.displayName;
                        cm.commentById = profile?.id;
                        cm.commentDate = Helper.getCurrentDateTimeString();
                        cm.postId = post.id;

                        var ref = commentListRef.push();
                        cm.key = ref.key;
                        ref.set(cm.toJson());
                        _keyForm.currentState!.reset();
                        comment.ct.clear();
                        
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                      // RouteStateScope.of(context).go("/post/${profile.id}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //  A google icon here
                        //  an External Package used here
                        //  Font_awesome_flutter package used
                        Text("Send Private comment"),
                      ],
                    )
                    //_saveButtons(),
                    // Image.asset('assets/card-sample-image.jpg'),
                    // Image.asset('assets/card-sample-image-2.jpg'),
                    ),
              ],
            )));
  }

  Widget CommentListCard() {
    return Container(
        child: StreamBuilder(
            stream: commentListRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (data == null) {
                  return Container();
                }
                var value = (data! as DatabaseEvent).snapshot;
                if (value == null) {
                  return Container();
                }

                List<Comment> commentList = [];
                for (final child in value.children) {
                  // Handle the post.
                  if (child.value != null) {
                    var comment =
                        Comment.fromJson(Helper.objectToJson(child.value!));

                    if (profile?.id == comment.postOwner ||
                        profile?.id == comment.commentById) {
                      commentList.add(comment);
                    } else if (profile?.companyCode != null) {
                      if (comment.companyCode == profile?.companyCode) {
                        commentList.add(comment);
                      }
                    }
                  }
                }

                commentList = commentList.reversed.toList();
                //return Container();
                return ListView.builder(
                  itemCount: commentList.length,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var comment = commentList[index];
                    var title = (comment.commentBy ?? '') +
                        ' ▪ ' +
                        Helper.getTimeAgo(Helper.stringToDate(
                            dateString: comment.commentDate!));
                    var subtitle = (comment.comment ?? '');
                    Widget? trailing = null;

                    if (isOwner) {
                      trailing = IconButton(
                        icon: const Icon(Icons.reply),
                        onPressed: () {
                          setState(() {
                            // _volume += 10;
                          });
                        },
                      );
                    }

                    return ListTile(
                      title: Text(title, style: TextStyle(fontSize: 12)),
                      isThreeLine: true,
                      subtitle: Text(subtitle),
                      leading: comment.avatar == null
                          ? Icon(Icons.person)
                          : CircleAvatar(
                              backgroundImage: NetworkImage(comment.avatar!)),
                      enableFeedback: true,
                      trailing: trailing,
                    );
                  },
                );
              }
              return Container();
            }));
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
            padding: EdgeInsets.only(top: 20),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text('Logout'),
                disabledColor: Colors.blueAccent.withOpacity(0.6),
                color: Colors.redAccent,
                onPressed: () => ref.read(GlobalProvider).logout()));
      },
    );
  }
}
