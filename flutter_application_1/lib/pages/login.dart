import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register.dart';
// import 'package:flutter_application_1/pages/showtip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = "";
  int number = 0;
  TextEditingController phoneNum = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void register() {
    // การสลับหน้าข้อมูลหน้าเก่ายังคงเดิม
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login(String phone, String password) {
    var data = {"phone": "0817399999", "password": "1111"};
    print(data);
    http
        .post(
          Uri.parse('http://10.160.49.241:3333/customers/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(data),
        )
        .then((value) {
          print(value.body);
        })
        .catchError((error) {
          log('Error: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEFF), // สีพื้นหลังชมพูอ่อน
      body: SingleChildScrollView(
        child: Column(
          children: [
            // รูปภาพด้านบน
            Image.asset(
              "asset/Zone25621029104150.jpg",
            ), // เปลี่ยน path ให้ตรงกับโปรเจค

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("หมายเลขโทรศัพท์"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: phoneController,
                    // controller: phoneNum,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
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
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: register,
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
