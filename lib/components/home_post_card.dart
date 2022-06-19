
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_saver_client/common/config.dart';

import 'package:pet_saver_client/models/post.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:photo_view/photo_view.dart';

class PostCard extends StatefulWidget {
  final PostModel profile;
  final ValueChanged<PostModel>? editCallback;
  final ValueChanged<PostModel>? deleteCallback;
  const PostCard(
      {Key? key, required this.profile, this.editCallback, this.deleteCallback})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // final _keyForm = GlobalKey<FormState>();

  late PostModel _post;

  @override
  void initState() {
    super.initState();
    _post = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            minLeadingWidth: 2,
            leading: Icon(Icons.person),
            title: Text("Riz Wong"),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: PhotoView(
              
              // customSize: Size(MediaQuery.of(context).size.width,150),
              imageProvider:
                  NetworkImage(Config.apiServer + "/posts/image/${_post.id}"),

              // initialScale: PhotoViewComputedScale.contained,
            ),
          ),
          ListTile(
            minLeadingWidth: 2,
            leading: const Icon(Icons.question_mark),
            title: _post.type == "cat"
                ? const Text("Lost")
                : const Text("Adoption"),
          ),
          ListTile(
            minLeadingWidth: 2,
            leading: const Icon(Icons.pets),
            title: Text("${_post.type}"),
          ),
          const ListTile(
            minLeadingWidth: 2,
            leading: Icon(Icons.lock_clock),
            title: Text("a day ago"),
          ),
          const ListTile(
            minLeadingWidth: 2,
            leading: Icon(Icons.location_on_rounded),
            title: Text("Tuen Mun District"),
          ),
          CupertinoButton(
                onPressed: (){
                   RouteStateScope.of(context).go("/post/${_post.id}");
                },
                child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              //  A google icon here
              //  an External Package used here
              //  Font_awesome_flutter package used
               Icon(Icons.remove_red_eye),
             
            ],
                ),)
        ],
      
      ),
    
    );
  }

  Widget _saveButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () =>
              widget.editCallback == null ? null : widget.editCallback!(_post),
          child: const Text('edit'),
        ),
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () => widget.deleteCallback == null
              ? null
              : widget.deleteCallback!(_post),
          child: const Text('delete'),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    //_keyForm.currentState!.dispose();
  }
}
      
    
    // print(this.error);

  
