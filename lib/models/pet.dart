// To parse this JSON data, do
//
//     final petModel = petModelFromJson(jsonString);

import 'dart:convert';

List<PetModel> petModelFromJson(String str) => List<PetModel>.from(json.decode(str).map((x) => PetModel.fromJson(x)));

String petModelToJson(List<PetModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PetModel {
    PetModel({
        this.name,
        this.about,
        this.breedId,
        this.imageBase64,
        this.cropImgBase64,
        this.createdBy,
        this.id,
        this.type,
        this.breed
    });

    String? name;
    String? about;
    int? breedId;
    String? imageBase64;
    String? cropImgBase64;
    int? createdBy;
    int? id;
    String? type;
    dynamic? breed;

    PetModel copyWith({
        String? name,
        String? about,
        int? breedId,
        String? imageBase64,
        String? cropImgBase64,
        int? createdBy,
        int? id,
        String? type,
        dynamic? breed
    }) => 
        PetModel(
            cropImgBase64: cropImgBase64 ?? this.cropImgBase64,
            name: name ?? this.name,
            about: about ?? this.about,
            breedId: breedId ?? this.breedId,
            imageBase64: imageBase64 ?? this.imageBase64,
            createdBy: createdBy ?? this.createdBy,
            id: id ?? this.id,
            type: type ?? this.type,
            breed: type ?? this.breed,
        );

    factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        name: json["name"],
        about: json["about"],
        breedId: json["breedID"],
        imageBase64: json["imageBase64"],
        cropImgBase64: json["cropImgBase64"],
        createdBy: json["createdBy"],
        id: json["id"],
        type: json["type"],
        breed: json["breed"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "about": about,
        "breedID": breedId,
        "imageBase64": imageBase64,
        "cropImgBase64":cropImgBase64,
        "createdBy": createdBy,
        "id": id,
        "type": type,
    };
}
