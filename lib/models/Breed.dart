// To parse this JSON data, do
//
//     final Breed = BreedFromJson(jsonString);

import 'dart:convert';

List<Breed> BreedFromJson(String str) => List<Breed>.from(json.decode(str).map((x) => Breed.fromJson(x)));

String BreedToJson(List<Breed> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Breed {
    Breed({
        this.name,
        this.id,
    });

    String? name;
    int? id;

    Breed copyWith({
        String? name,
        int? id,
    }) => 
        Breed(
            name: name ?? this.name,
            id: id ?? this.id,
        );

    factory Breed.fromJson(Map<String, dynamic> json) => Breed(
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "id": id == null ? null : id,
    };
}
