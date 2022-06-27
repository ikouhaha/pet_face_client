// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Notification> commentFromJson(String str) => List<Notification>.from(json.decode(str).map((x) => Notification.fromJson(x)));

String commentToJson(List<Notification> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notification {
    Notification({
        this.key,
        this.type,
        this.jsonValue,
    });

    String? key;
    String? type;
    String? jsonValue;

    Notification copyWith({
        String? key,
        String? type,
        String? jsonValue,
        
    }) => 
        Notification(
            key: key ?? this.key,
            type: type ?? this.type,
            jsonValue: jsonValue ?? this.jsonValue,
            
        );

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        key: json["key"] == null ? null : json["key"],
        type: json["type"] == null ? null : json["type"],
        jsonValue: json["jsonValue"] == null ? null : json["jsonValue"],
        
    );

    Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "type": type == null ? null : type,
        "jsonValue": jsonValue == null ? null : jsonValue,
    };
}
