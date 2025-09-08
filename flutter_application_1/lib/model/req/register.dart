// To parse this JSON data, do
//
//     final customerRegisterPostReqDart = customerRegisterPostReqDartFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostReqDart customerRegisterPostReqDartFromJson(String str) =>
    CustomerRegisterPostReqDart.fromJson(json.decode(str));

String customerRegisterPostReqDartToJson(CustomerRegisterPostReqDart data) =>
    json.encode(data.toJson());

class CustomerRegisterPostReqDart {
  String fullname;
  String phone;
  String email;
  String image;
  String password;

  CustomerRegisterPostReqDart({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
  });

  factory CustomerRegisterPostReqDart.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostReqDart(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
    "password": password,
  };
}
