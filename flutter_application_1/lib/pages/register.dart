import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/req/register.dart';

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
  String url = '';
  String errorText = "";
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

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

    // ✅ เช็กรูปแบบอีเมล
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        errorText = "รูปแบบอีเมลไม่ถูกต้อง";
      });
      return;
    }

    // ✅ เช็กความยาวหมายเลขโทรศัพท์
    if (phone.length < 10) {
      setState(() {
        errorText = "หมายเลขโทรศัพท์ต้องมีอย่างน้อย 10 หลัก";
      });
      return;
    }

    // ✅ สร้าง CustomerRegisterPostReqDart object
    final registerData = CustomerRegisterPostReqDart(
      fullname: user,
      phone: phone,
      email: email,
      image: "", // ใส่ค่าว่างไว้ก่อน หรือจะให้ user upload รูปภาพก็ได้
      password: password,
    );

    final endpoint = Uri.parse('http://10.160.63.18:3000/customers');
    print('POST ไปยัง /customers: $endpoint');
    print('ข้อมูลที่ส่ง: ${customerRegisterPostReqDartToJson(registerData)}');

    http
        .post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: customerRegisterPostReqDartToJson(
            registerData,
          ), // ใช้โมเดลในการแปลง JSON
        )
        .then((response) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');

          if (response.statusCode == 200 || response.statusCode == 201) {
            setState(() {
              errorText = "✅ ลงทะเบียนสำเร็จ!";
            });
            // กลับไปหน้า Login หลังจาก 2 วินาที
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          } else {
            setState(() {
              errorText = "❌ ลงทะเบียนไม่สำเร็จ: ${response.body}";
            });
          }
        })
        .catchError((e) {
          print('Error: $e');
          setState(() {
            errorText = "❌ ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้: $e";
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEFF),
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
        backgroundColor: const Color(0xFFFDEEFF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildField('ชื่อ-นามสกุล', userController),
              buildField(
                'หมายเลขโทรศัพท์',
                phoneController,
                type: TextInputType.number,
                isPhone: true,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: errorText.contains('✅')
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: errorText.contains('✅')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  child: Text(
                    errorText,
                    style: TextStyle(
                      color: errorText.contains('✅')
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'สมัครสมาชิก',
                  style: TextStyle(fontSize: 16),
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
    bool isPhone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscure,
          inputFormatters: isPhone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
            hintText: _getHintText(label),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  String _getHintText(String label) {
    switch (label) {
      case 'ชื่อ-นามสกุล':
        return 'กรอกชื่อและนามสกุล';
      case 'หมายเลขโทรศัพท์':
        return 'เช่น 0812345678';
      case 'อีเมล':
        return 'เช่น example@email.com';
      case 'รหัสผ่าน':
        return 'กรอกรหัสผ่าน';
      case 'ยืนยันรหัสผ่าน':
        return 'กรอกรหัสผ่านอีกครั้ง';
      default:
        return '';
    }
  }
}
