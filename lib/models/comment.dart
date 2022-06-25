// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    Comment({
        this.key,
        this.postId,
        this.avatar,
        this.comment,
        this.commentDate,
        this.commentBy,
        this.commentById,
    });

    String? key;
    int? postId;
    String? avatar;
    String? comment;
    String? commentDate;
    String? commentBy;
    int? commentById;

    Comment copyWith({
        String? key,
        int? postId,
        String? avatar,
        String? comment,
        String? commentDate,
        String? commentBy,
        int? commentById,
    }) => 
        Comment(
            key: key ?? this.key,
            postId: postId ?? this.postId,
            avatar: avatar ?? this.avatar,
            comment: comment ?? this.comment,
            commentDate: commentDate ?? this.commentDate,
            commentBy: commentBy ?? this.commentBy,
            commentById: commentById ?? this.commentById,
        );

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        key: json["key"] == null ? null : json["key"],
        postId: json["postId"] == null ? null : json["postId"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        comment: json["comment"] == null ? null : json["comment"],
        commentDate: json["commentDate"] == null ? null : json["commentDate"],
        commentBy: json["commentBy"] == null ? null : json["commentBy"],
        commentById: json["commentById"] == null ? null : json["commentById"],
    );

    Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "postId": postId == null ? null : postId,
        "avatar": avatar == null ? null : avatar,
        "comment": comment == null ? null : comment,
        "commentDate": commentDate == null ? null : commentDate,
        "commentBy": commentBy == null ? null : commentBy,
        "commentById": commentById == null ? null : commentById,
    };
}
