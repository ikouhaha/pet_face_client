// To parse this JSON data, do
//
//     final PostModel = PostModelFromJson(jsonString);

import 'dart:convert';

List<PostModel> PostModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

PostModel PostModelObjFromJson(String str) => PostModel.fromJson(json.decode(str));


String PostModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel(
      {this.type,
      this.about,
      this.breedID,
      this.imageBase64,
      this.createdBy,
      this.id,
      this.breed,
      this.createdByName,
      this.companyCode,
      this.imageFilename,
      this.petType,
      this.cropImageBase64,
      this.district,
      this.districtId,
      this.createdOn
      });

  String? type;
  String? about;
  int? breedID;
  String? imageBase64;
  String? cropImageBase64;

  int? createdBy;
  int? id;
  int? districtId;
  String? companyCode;
  String? imageFilename;
  String? petType;
   
  String? district;
  String? breed;
  String? createdByName;
  DateTime? createdOn;


  PostModel copyWith({
    String? name,
    String? about,
    int? breedID,
    String? imageBase64,
    int? createdBy,
    int? id,
    String? type,
    String? breed,
    String? companyCode,
    String? imageFilename,
    String? petType,
    String? district,
    int? districtId,
    DateTime? createdOn,
    String? createdByName,
    
  }) =>
      PostModel(
        about: about ?? this.about,
        breedID: breedID ?? this.breedID,
        imageBase64: imageBase64 ?? this.imageBase64,
        createdBy: createdBy ?? this.createdBy,
        id: id ?? this.id,
        type: type ?? this.type,
        breed: breed ?? this.breed,
        companyCode: companyCode ?? this.companyCode,
        imageFilename: imageFilename ?? this.imageFilename,
        petType: petType ?? this.petType,
        cropImageBase64: cropImageBase64?? this.cropImageBase64,
        district: district ?? this.district,
        districtId: districtId ?? this.districtId,
        createdOn: createdOn ?? this.createdOn,
        createdByName: createdByName ?? this.createdByName,

      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        about: json["about"],
        breedID: json["breedID"],
        imageBase64: json["imageBase64"],
        createdBy: json["createdBy"],  
        id: json["id"],
        type: json["type"],
        breed: json["breed"],
        companyCode: json["companyCode"],
        imageFilename: json["imageFilename"],
        petType: json["petType"],
        createdByName: json["createdByName"],
        cropImageBase64: json["cropImageBase64"],
        district: json["district"],
        districtId: json["districtId"],
        createdOn: DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "about": about,
        "breedID": breedID,
        "imageBase64": imageBase64,
        "createdBy": createdBy,
        "id": id,
        "type": type,
        "companyCode": companyCode,
        "imageFilename": imageFilename,
        "petType": petType,
        "cropImageBase64" : cropImageBase64,
        "districtId": districtId,
      };
}
