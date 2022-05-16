
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_saver_client/router/route_state.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pet_saver_client/common/config.dart';

import 'package:pet_saver_client/models/pet.dart';

import 'package:pet_saver_client/providers/global_provider.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class PetCard extends StatefulWidget {
  final PetModel profile;
  final ValueChanged<PetModel>? editCallback;
  final ValueChanged<PetModel>? deleteCallback;
  
  const PetCard({Key? key, required this.profile, this.editCallback,this.deleteCallback})
      : super(key: key);

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard>{
  

  late AnimationController _controller;
  late PetModel _pet;

  @override
  void initState() {
    super.initState();
    this._pet = widget.profile;
  }

 
  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: PhotoView(
                // customSize: Size(MediaQuery.of(context).size.width,150),
                imageProvider:
                    NetworkImage(Config.apiServer + "/pets/image/${_pet.id}"),

                initialScale: PhotoViewComputedScale.contained,
              ),
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(Icons.pets),
              title: Text("${_pet.type}"),
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(Icons.lock_clock),
              title: Text("a day ago"),
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(Icons.location_on_rounded),
              title: Text("Tuen Mun District"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${_pet.about}",
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
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
      children: [
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () =>
              widget.editCallback == null ? null : widget.editCallback!(_pet),
          child: const Text('edit'),
        ),
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () =>
              widget.deleteCallback == null ? null : widget.deleteCallback!(_pet),
          child: const Text('delete'),
        ),
        FlatButton(
          textColor: const Color(0xFF6200EE),
          onPressed: () { 
            RouteStateScope.of(context).go("/post/${_pet.id}");
          },
          child: const Text('view'),
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

  
