// To parse this JSON data, do
//
//     final tripDetailRes = tripDetailResFromJson(jsonString);

import 'dart:convert';

TripDetailRes tripDetailResFromJson(String str) =>
    TripDetailRes.fromJson(json.decode(str));

String tripDetailResToJson(TripDetailRes data) => json.encode(data.toJson());

class TripDetailRes {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  TripDetailRes({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory TripDetailRes.fromJson(Map<String, dynamic> json) => TripDetailRes(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}
