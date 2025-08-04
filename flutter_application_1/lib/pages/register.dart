import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController autpassController = TextEditingController();

  String errorText = "";

  void register() {
    String user = userController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String autpass = autpassController.text.trim();

    // ✅ เช็กช่องว่าง
    if (user.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        autpass.isEmpty) {
      setState(() {
        errorText = "กรุณากรอกข้อมูลให้ครบทุกช่อง";
      });
      return;
    }

    // ✅ เช็กรหัสผ่านซ้ำ
    if (password != autpass) {
      setState(() {
        errorText = "รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน";
      });
      return;
    }

    final url = Uri.parse('http://10.160.49.241:3333/cutomers');
    print('POST ไปยัง /customers: $url');

    http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'user': user,
            'phone': phone,
            'email': email,
            'password': password,
          }),
        )
        .then((response) {
          if (response.statusCode == 200) {
            setState(() {
              errorText = "✅ ลงทะเบียนสำเร็จ!";
            });
          } else {
            setState(() {
              errorText = "❌ ลงทะเบียนไม่สำเร็จ: ${response.body}";
            });
          }
        })
        .catchError((e) {
          setState(() {
            errorText = "❌ ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้: $e";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildField('ชื่อนามสกุล', userController),
              buildField(
                'หมายเลขโทรศัพท์',
                phoneController,
                type: TextInputType.phone,
              ),
              buildField(
                'อีเมล',
                emailController,
                type: TextInputType.emailAddress,
              ),
              buildField('รหัสผ่าน', passwordController, obscure: true),
              buildField('ยืนยันรหัสผ่าน', autpassController, obscure: true),
              const SizedBox(height: 20),
              if (errorText.isNotEmpty)
                Text(errorText, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'สมัครสมาชิก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscure,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
