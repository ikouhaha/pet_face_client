import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/common/helper.dart';
import 'package:pet_saver_client/models/Breed.dart';
import 'package:pet_saver_client/models/comment.dart';
import 'package:pet_saver_client/models/user.dart';

void main() {
  test('uuid', () {
    expect(Helper.uuid(), isNotNull);
  });

  test('getTimeAgo', () {
    expect(Helper.getTimeAgo(DateTime.now()), isNotNull);
  });

  test('objectToJson', () {
   Breed breed = Breed();
    breed.id = 1;
    breed.name = "test";

    Map expectResult = {
      "id": 1,
      "name": "test"
    };
      
    expect(Helper.objectToJson(breed), expectResult);
  });

  test('getCurrentDateTimeString', () {
    expect(Helper.getCurrentDateTimeString(), isNotNull);
  });



  test('test timeStampToDatetime', () {
    var timenow = DateTime.now().microsecondsSinceEpoch;
   var test = Helper.timeStampToDatetime(timenow);
   var expectResult =  DateTime.fromMicrosecondsSinceEpoch(timenow);
   
    expect(test, expectResult);
  });

  test('test showErrorToast', () {
    Helper.showErrorToast(msg: "test");
  });
}