import 'dart:convert';

List<Option> optionsFromJson(String str) => List<Option>.from(json.decode(str).map((x) => Option.fromJson(x)));

String optionsToJson(List<Option> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Option {
    Option({
        this.name,
        this.value,
    });

    String? name;
    dynamic value;

    Option copyWith({
        String? name,
        dynamic value,
    }) => 
        Option(
            name: name ?? this.name,
            value: value ?? this.value,
        );

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["name"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
    };
}