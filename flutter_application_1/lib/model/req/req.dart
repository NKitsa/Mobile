// To parse this JSON data, do
//
//     final customerLoginGetReqDart = customerLoginGetReqDartFromJson(jsonString);

import 'dart:convert';

CustomerLoginGetReqDart customerLoginGetReqDartFromJson(String str) =>
    CustomerLoginGetReqDart.fromJson(json.decode(str));

String customerLoginGetReqDartToJson(CustomerLoginGetReqDart data) =>
    json.encode(data.toJson());

class CustomerLoginGetReqDart {
  String phone;
  String password;

  CustomerLoginGetReqDart({required this.phone, required this.password});

  factory CustomerLoginGetReqDart.fromJson(Map<String, dynamic> json) =>
      CustomerLoginGetReqDart(phone: json["phone"], password: json["password"]);

  Map<String, dynamic> toJson() => {"phone": phone, "password": password};
}
