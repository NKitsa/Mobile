// To parse this JSON data, do
//
//     final tripRes = tripResFromJson(jsonString);

import 'dart:convert';

List<TripRes> tripResFromJson(String str) =>
    List<TripRes>.from(json.decode(str).map((x) => TripRes.fromJson(x)));

String tripResToJson(List<TripRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripRes {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  TripRes({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory TripRes.fromJson(Map<String, dynamic> json) => TripRes(
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
