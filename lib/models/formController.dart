import 'package:flutter/widgets.dart';

class FormController {
    late TextEditingController ct;
    late FocusNode fn;
    

  FormController({TextEditingController? ct,FocusNode? fn}) {
    this.ct = ct ?? TextEditingController();
    this.fn = fn ?? FocusNode();    
  }

  dispose(){
    if(ct!=null){
      ct.dispose();
    }

    if(fn!=null){
      fn.dispose();   
    }
    
     
  }

}