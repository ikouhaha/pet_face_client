// To parse this JSON data, do
//
//     final findSimilarityResponse = findSimilarityResponseFromJson(jsonString);

import 'dart:convert';

List<FindSimilarityResponse> findSimilarityResponseFromJson(String str) => List<FindSimilarityResponse>.from(json.decode(str).map((x) => FindSimilarityResponse.fromJson(x)));

String findSimilarityResponseToJson(List<FindSimilarityResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FindSimilarityResponse {
    FindSimilarityResponse({
        this.distance,
        this.filename,
    });

    double? distance;
    String? filename;

    FindSimilarityResponse copyWith({
        double? distance,
        String? filename,
    }) => 
        FindSimilarityResponse(
            distance: distance ?? this.distance,
            filename: filename ?? this.filename,
        );

    factory FindSimilarityResponse.fromJson(Map<String, dynamic> json) => FindSimilarityResponse(
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        filename: json["filename"] == null ? null : json["filename"],
    );

    Map<String, dynamic> toJson() => {
        "distance": distance == null ? null : distance,
        "filename": filename == null ? null : filename,
    };
}
