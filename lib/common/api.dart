import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'config.dart';


asyncUploadImage(String endpoint,String text, XFile imageFile) async{
  var url = Config.apiServer + endpoint;
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();
  
  
   //create multipart request for POST or PATCH method
   var request = http.MultipartRequest("POST", Uri.parse(url));
   //add text fields
   request.fields["text_field"] = text;
   //create multipart using filepath, string or bytes
   var pic = await http.MultipartFile(
     "image"
     ,stream     
     ,length
     ,filename:imageFile.name);
   //add multipart to request
   request.files.add(pic);
   var response = await request.send();

   //Get the response from the server
   var responseData = await response.stream.toBytes();
   var responseString = String.fromCharCodes(responseData);
   print(responseString);
}