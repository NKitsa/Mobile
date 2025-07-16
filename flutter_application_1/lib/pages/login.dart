import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEEFF), // สีพื้นหลังชมพูอ่อน
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
                  // ช่องกรอกเบอร์โทรศัพท์
                  const Text("หมายเลขโทรศัพท์"),
                  const SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอกรหัสผ่าน
                  const Text("รหัสผ่าน"),
                  const SizedBox(height: 5),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ปุ่ม "เข้าสู่ระบบ" และ "ลงทะเบียนใหม่"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "ลงทะเบียนใหม่",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
