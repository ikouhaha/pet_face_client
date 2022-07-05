import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/app.dart';
import 'package:pet_saver_client/common/config.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/common/sharePerfenceService.dart';
import 'package:pet_saver_client/firebase_options.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/findSimilarity.dart';
import 'package:pet_saver_client/models/formController.dart';
import 'package:pet_saver_client/models/user.dart';
import 'package:pet_saver_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

   
  test('test formcontroller',(){
    FormController fc = FormController();
    fc.ct.text = "test";
    expect(fc.ct.text, "test");

  });

   test('test focus',(){
    FormController fc = FormController();
    fc.fn.requestFocus();
    fc.fn.unfocus();
    expect(fc.fn.hasFocus, false);
  });

  test('test formcontroller dispose',(){
    FormController fc = FormController();
    fc.dispose();

  });
  

  

}