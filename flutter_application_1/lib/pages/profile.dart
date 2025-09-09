import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/req/res/res_profile_customer.dart';

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TripDetailRes? user;
  late Future<void> loadData;

  final _fullnameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = _loadProfile();
  }

  Future<void> _loadProfile() async {
    final url = "http://10.160.63.18:3000/customers/${widget.idx}";
    log("GET $url");

    final res = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode == 200) {
      user = tripDetailResFromJson(res.body);

      _fullnameCtrl.text = user!.fullname;
      _phoneCtrl.text = user!.phone;
      _emailCtrl.text = user!.email;
      _imageCtrl.text = user!.image;
    } else {
      throw Exception("โหลดข้อมูลล้มเหลว: ${res.statusCode}");
    }
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6EAF7),
        elevation: 0,
        title: const Text("ข้อมูลส่วนตัว"),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }
          if (user == null) {
            return const Center(child: Text("ไม่พบข้อมูลผู้ใช้"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar (จาก image URL)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user!.image),
                  onBackgroundImageError: (_, __) => const Icon(
                    Icons.account_circle,
                    size: 120,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Fullname
                TextField(
                  controller: _fullnameCtrl,
                  decoration: const InputDecoration(
                    labelText: "ชื่อ-นามสกุล",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                TextField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: "หมายเลขโทรศัพท์",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: "อีเมล์",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Image URL
                TextField(
                  controller: _imageCtrl,
                  decoration: const InputDecoration(
                    labelText: "รูปภาพ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: call PUT/POST API บันทึกข้อมูล
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("กดบันทึก (ตัวอย่าง)")),
                      );
                    },
                    child: const Text(
                      "บันทึกข้อมูล",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
