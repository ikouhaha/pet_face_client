import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pet_saver_client/common/config.dart';

import 'package:pet_saver_client/models/post.dart';

import 'package:pet_saver_client/providers/global_provider.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class PostCard extends StatefulWidget {
  final PostModel profile;
  final ValueChanged<PostModel>? editCallback;
  final ValueChanged<PostModel>? deleteCallback;

  const PostCard(
      {Key? key, required this.profile, this.editCallback, this.deleteCallback})
      : super(key: key);

  @override
  _postCardState createState() => _postCardState();
}

class _postCardState extends State<PostCard> {
  late AnimationController _controller;
  late PostModel _post;

  @override
  void initState() {
    super.initState();
    this._post = widget.profile;
  }

   dynamic getImageProvider(){
    if(!Config.isTest){
      return NetworkImage(Config.apiServer + "/posts/image/${_post.id}");
    }else{
      return const AssetImage('assets/test.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: PhotoView(
                // customSize: Size(MediaQuery.of(context).size.width,150),
                imageProvider:getImageProvider(),
                initialScale: PhotoViewComputedScale.contained,
              ),
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(Icons.pets),
              title: Text("${_post.type}"),
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(Icons.lock_clock),
              title: Text(Helper.getTimeAgo(_post.createdOn)),
            ),
            _saveButtons(),
            // Image.asset('assets/card-sample-image.jpg'),
            // Image.asset('assets/card-sample-image-2.jpg'),
          ],
        ));
  }

  Widget _saveButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // alignment: MainAxisAlignment.start,
        children: [
          IconButton(
            color: Colors.blue,
            icon: Icon(Icons.edit),
            onPressed: () {
              widget.editCallback?.call(_post);
            },
          ),
          IconButton(
            color: Colors.blue,
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.deleteCallback?.call(_post);
            },
          ),
          IconButton(
            color: Colors.blue,
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              RouteStateScope.of(context).go("/post/${_post.id}");
            },
          ),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    //_keyForm.currentState!.dispose();
  }
}
      
    
    // print(this.error);

  
