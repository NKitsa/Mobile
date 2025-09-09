// To parse this JSON data, do
//
//     final tripDetailRes = tripDetailResFromJson(jsonString);

import 'dart:convert';

TripDetailRes tripDetailResFromJson(String str) =>
    TripDetailRes.fromJson(json.decode(str));

String tripDetailResToJson(TripDetailRes data) => json.encode(data.toJson());

class TripDetailRes {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripDetailRes({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripDetailRes.fromJson(Map<String, dynamic> json) => TripDetailRes(
    idx: json["idx"],
    name: json["name"],
    country: json["country"],
    coverimage: json["coverimage"],
    detail: json["detail"],
    price: json["price"],
    duration: json["duration"],
    destinationZone: json["destination_zone"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}
