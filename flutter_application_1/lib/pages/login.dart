import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มบรรทัดนี้
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/req/res/res.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtip.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/req/res/res.dart';
import 'package:flutter_application_1/model/req/req.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = "";
  int number = 0;
  String url = '';
  TextEditingController phoneNum = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login(String phone, String password) {
    // วิธีที่ 1: ใช้ custom class (ถ้ามี)
    CustomerLoginGetReqDart req = CustomerLoginGetReqDart(
      phone: phone, // ใช้ parameter จริงแทน hardcode
      password: password,
    );

    http
        .post(
          Uri.parse('http://10.160.63.18:3000/customers/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginGetReqDartToJson(req), // ใช้ toJson function
        )
        .then((value) {
          log(value.body);
          if (value.statusCode == 200) {
            CustomerLoginPostResDart customerLoginPostResponse =
                customerLoginPostResDartFromJson(value.body);
            log(customerLoginPostResponse.customer.fullname);
            log(customerLoginPostResponse.customer.email);

            // นำทางไป ShowTripPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowTripPage(cid: customerLoginPostResponse.customer.idx),
              ),
            );
          } else {
            log('Login failed: ${value.statusCode}');
          }
        })
        .catchError((error) {
          log('Error: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("asset/Zone25621029104150.jpg"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("หมายเลขโทรศัพท์"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: phoneController,
                    keyboardType:
                        TextInputType.number, // เปลี่ยนจาก phone เป็น number
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // อนุญาตเฉพาะตัวเลข 0-9
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText:
                          "กรอกหมายเลขโทรศัพท์", // เพิ่ม hint text (ถ้าต้องการ)
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("รหัสผ่าน"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "กรอกรหัสผ่าน", // เพิ่ม hint text (ถ้าต้องการ)
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => register(),
                        child: const Text(
                          "ลงทะเบียนใหม่",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String phone = phoneController.text.trim();
                          String password = passwordController.text.trim();
                          login(phone, password);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("เข้าสู่ระบบ"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(text, style: const TextStyle()),
          ],
        ),
      ),
    );
  }
}
