
// To parse this JSON data, do
//
//     final storage = storageFromJson(jsonString);

import 'dart:convert';

Storage storageFromJson(String str) => Storage.fromJson(json.decode(str));

String storageToJson(Storage data) => json.encode(data.toJson());

class Storage {
    Storage({
         this.token,
    });

    String? token;

    Storage copyWith({
        required String? token,
    }) => 
        Storage(
            token: token 
        );

    factory Storage.fromJson(Map<String, dynamic> json) => Storage(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
