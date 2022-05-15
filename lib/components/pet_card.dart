import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pet_saver_client/common/config.dart';

import 'package:pet_saver_client/models/pet.dart';

import 'package:pet_saver_client/providers/global_provider.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class PetCard extends ConsumerStatefulWidget {
  final PetModel profile;
  final ValueChanged<PetModel>? editCallback;
  final ValueChanged<PetModel>? deleteCallback;
  const PetCard({Key? key, required this.profile, this.editCallback,this.deleteCallback})
      : super(key: key);

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends ConsumerState<PetCard>
    with TickerProviderStateMixin {
  final _keyForm = GlobalKey<FormState>();

  late AnimationController _controller;
  late PetModel _pet;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
    this._pet = widget.profile;
  }

  Widget getImg(url, _controller) {
    return ExtendedImage.network(
      url,
      fit: BoxFit.contain,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            _controller.reset();
            break;
          // return Image.asset(
          //   'assets/images/loading.gif',
          //   fit: BoxFit.fill,
          // );
          case LoadState.completed:
            _controller.forward();
            return FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: 400,
                height: 300,
              ),
            );
          case LoadState.failed:
            _controller.reset();
            state.imageProvider.evict();
            // return Image.asset(
            //   'assets/images/failed.jpg',
            // );
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Form(
          key: _keyForm,
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
          )),
    );
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
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
      
    
    // print(this.error);

  
