import 'package:flutter_test/flutter_test.dart';
import 'package:pet_saver_client/common/helper.dart';

void main() {
  test('test timeStampToDatetime', () {
   var test1 = Helper.timeStampToDatetime(DateTime.now().microsecondsSinceEpoch);
    var test2 = Helper.getTimeAgo(test1);
    print(test1);
    print(test2);
  });

  test('Counter value should be incremented', () {
   
  });
}