import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มบรรทัดนี้
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtip.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login(String phone, String password) {
    var data = {"phone": phone, "password": password}; // ใช้ข้อมูลที่กรอกจริง
    print(data);
    http
        .post(
          Uri.parse('http://192.168.1.105:3000/customers/login'),
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
