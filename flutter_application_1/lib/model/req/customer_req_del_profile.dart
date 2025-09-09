// To parse this JSON data, do
//
//     final customerDelReq = customerDelReqFromJson(jsonString);

import 'dart:convert';

CustomerDelReq customerDelReqFromJson(String str) =>
    CustomerDelReq.fromJson(json.decode(str));

String customerDelReqToJson(CustomerDelReq data) => json.encode(data.toJson());

class CustomerDelReq {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CustomerDelReq({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CustomerDelReq.fromJson(Map<String, dynamic> json) => CustomerDelReq(
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
