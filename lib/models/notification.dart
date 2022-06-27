// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Notifications> notificationsFromJson(String str) => List<Notifications>.from(json.decode(str).map((x) => Notifications.fromJson(x)));

String notificationsToJson(List<Notifications> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notifications {
    Notifications({
        this.key,
        this.type,
        this.jsonValue,
    });

    String? key;
    String? type;
    String? jsonValue;

    Notifications copyWith({
        String? key,
        String? type,
        String? jsonValue,
        
    }) => 
        Notifications(
            key: key ?? this.key,
            type: type ?? this.type,
            jsonValue: jsonValue ?? this.jsonValue,
            
        );

    factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
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
