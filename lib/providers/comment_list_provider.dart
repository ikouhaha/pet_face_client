

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:flutter/cupertino.dart';


final ChangeNotifierProvider<CommentListNotifier> commentListProvider =
    ChangeNotifierProvider((_) => CommentListNotifier());

class CommentListNotifier extends ChangeNotifier {
   List<Comment> _commentList = [];

   get commentList => _commentList;

   void setList(List<Comment> list){
      _commentList = list;
      notifyListeners();
   }

  @override
  String toString() {
    // TODO: implement toString
    return "length: ${_commentList.length}";
  }

}


