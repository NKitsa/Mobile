// To parse this JSON data, do
//
//     final customerUpdateReq = customerUpdateReqFromJson(jsonString);

import 'dart:convert';

CustomerUpdateReq customerUpdateReqFromJson(String str) =>
    CustomerUpdateReq.fromJson(json.decode(str));

String customerUpdateReqToJson(CustomerUpdateReq data) =>
    json.encode(data.toJson());

class CustomerUpdateReq {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomerUpdateReq({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomerUpdateReq.fromJson(Map<String, dynamic> json) =>
      CustomerUpdateReq(
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
