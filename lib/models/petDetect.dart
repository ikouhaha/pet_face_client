import 'dart:convert';

List<PetDetectResponse> petDetectResponseFromJson(String str) => List<PetDetectResponse>.from(json.decode(str).map((x) => PetDetectResponse.fromJson(x)));

String petDetectResponseToJson(List<PetDetectResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PetDetectResponse {
    PetDetectResponse({
        this.cropImgs,
        this.labelImg,
        this.name,
    });

    List<String>? cropImgs;
    String? labelImg;
    String? name;

    PetDetectResponse copyWith({
        List<String>? cropImgs,
        String? labelImg,
        String? name,
    }) => 
        PetDetectResponse(
            cropImgs: cropImgs ?? this.cropImgs??[],
            labelImg: labelImg ?? this.labelImg,
            name: name ?? this.name,
        );

    factory PetDetectResponse.fromJson(Map<String, dynamic> json) => PetDetectResponse(
        cropImgs: List<String>.from(json["cropImgs"].map((x) => x)),
        labelImg: json["labelImg"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "cropImages": List<dynamic>.from(cropImgs!.map((x) => x)),
        "labelImg": labelImg,
        "name": name,
    };
}
