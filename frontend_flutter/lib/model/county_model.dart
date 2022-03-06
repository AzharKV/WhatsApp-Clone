// To parse this JSON data, do
//
//     final countryModel = countryModelFromMap(jsonString);

import 'dart:convert';

CountryModel countryModelFromMap(String str) =>
    CountryModel.fromMap(json.decode(str));

String countryModelToMap(CountryModel data) => json.encode(data.toMap());

class CountryModel {
  CountryModel({
    required this.data,
  });

  List<Datum> data;

  factory CountryModel.fromMap(Map<String, dynamic> json) => CountryModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });

  String name;
  String flag;
  String code;
  String dialCode;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        name: json["name"],
        flag: json["flag"],
        code: json["code"],
        dialCode: json["dial_code"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "flag": flag,
        "code": code,
        "dial_code": dialCode,
      };
}
