// To parse this JSON data, do
//
//     final PostModel = PostModelFromJson(jsonString);

import 'dart:convert';

List<PostModel> PostModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String PostModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel(
      {this.type,
      this.about,
      this.breedId,
      this.imageBase64,
      this.createdBy,
      this.id,
      this.breed,
      this.createBy,
      this.companyCode,
      this.imageFilename,
      this.petType,
      this.cropImageBase64,
      this.district
      
      });

  String? type;
  String? about;
  int? breedId;
  String? imageBase64;
  String? cropImageBase64;

  int? createdBy;
  int? id;
  String? companyCode;
  String? imageFilename;
   String? petType;
   String? district;
  dynamic breed;
  dynamic createBy;

  PostModel copyWith({
    String? name,
    String? about,
    int? breedId,
    String? imageBase64,
    int? createdBy,
    int? id,
    String? type,
    dynamic? breed,
    String? companyCode,
    String? imageFilename,
    String? petType,
    String? district
    
  }) =>
      PostModel(
        about: about ?? this.about,
        breedId: breedId ?? this.breedId,
        imageBase64: imageBase64 ?? this.imageBase64,
        createdBy: createdBy ?? this.createdBy,
        id: id ?? this.id,
        type: type ?? this.type,
        breed: type ?? this.breed,
        companyCode: companyCode ?? this.companyCode,
        imageFilename: imageFilename ?? this.imageFilename,
        petType: petType ?? this.petType,
        cropImageBase64: cropImageBase64?? this.cropImageBase64,
        district: district ?? this.district
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        about: json["about"],
        breedId: json["breedID"],
        imageBase64: json["imageBase64"],
        createdBy: json["createdBy"],
        id: json["id"],
        type: json["type"],
        breed: json["breed"],
        companyCode: json["companyCode"],
        imageFilename: json["imageFilename"],
        petType: json["petType"],
        createBy: json["createBy"],
        cropImageBase64: json["cropImageBase64"],
        district: json["district"]
      );

  Map<String, dynamic> toJson() => {
        "about": about,
        "breedID": breedId,
        "imageBase64": imageBase64,
        "createdBy": createdBy,
        "id": id,
        "type": type,
        "companyCode": companyCode,
        "imageFilename": imageFilename,
        "petType": petType,
        "cropImageBase64" : cropImageBase64,
        "district": district
      };
}
