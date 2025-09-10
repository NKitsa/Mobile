import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;

// โมเดล GET โปรไฟล์
import 'package:flutter_application_1/model/req/res/res_profile_customer.dart';
// โมเดล PUT อัพเดทโปรไฟล์
import 'package:flutter_application_1/model/req/customer_req_profile.dart';
// โมเดล DELETE ยกเลิกสมาชิก
import 'package:flutter_application_1/model/req/customer_req_del_profile.dart';

class ProfilePage extends StatefulWidget {
  final int idx;
  const ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _base = ""; // จะไปโหลดจาก config.json

  TripDetailRes? user;
  late Future<void> loadData;
  bool _saving = false;

  final _fullnameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // โหลดค่า apiEndpoint จาก config
    Configuration.getConfig().then((config) {
      setState(() {
        _base = config['apiEndpoint'];
        loadData = _loadProfile(); // เริ่มโหลดข้อมูลหลังจากได้ค่า _base แล้ว
      });
    });
  }

  Future<void> _loadProfile() async {
    final url = "$_base/customers/${widget.idx}";
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
      setState(() {});
    } else {
      throw Exception("โหลดข้อมูลล้มเหลว: ${res.statusCode}");
    }
  }

  Future<void> _updateProfile() async {
    if (_saving) return;

    // ตรวจสอบข้อมูลเบื้องต้น
    if (_fullnameCtrl.text.trim().isEmpty) {
      _showSnack("กรุณากรอกชื่อ-นามสกุล");
      return;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      _showSnack("กรุณากรอกอีเมล");
      return;
    }

    setState(() => _saving = true);

    final url = "$_base/customers/${widget.idx}";
    log("PUT $url");

    final req = CustomerUpdateReq(
      idx: widget.idx,
      fullname: _fullnameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      image: _imageCtrl.text.trim(),
    );

    try {
      final res = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: customerUpdateReqToJson(req),
      );

      if (res.statusCode == 200) {
        _showSnack("บันทึกข้อมูลเรียบร้อย");
        await _loadProfile(); // รีเฟรชข้อมูล
      } else {
        _showSnack("อัพเดทไม่สำเร็จ: ${res.statusCode}");
      }
    } catch (e) {
      _showSnack("เกิดข้อผิดพลาด: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteProfile() async {
    final url = "$_base/customers/${widget.idx}";
    log("DELETE $url");

    final req = CustomerDelReq(
      idx: widget.idx,
      fullname: _fullnameCtrl.text,
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
      image: _imageCtrl.text,
    );

    try {
      final res = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: customerDelReqToJson(req),
      );

      if (res.statusCode == 200) {
        _showSnack("ลบข้อมูลเรียบร้อย");
        if (mounted) {
          // กลับหน้าแรก/หน้า login
          Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
        }
      } else {
        _showSnack("ลบไม่สำเร็จ: ${res.statusCode}");
      }
    } catch (e) {
      _showSnack("เกิดข้อผิดพลาด: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        actions: [
          // ปุ่มยกเลิกสมาชิก ด้านขวาบน
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () async {
                final ok = await _confirmDelete();
                if (ok == true) {
                  await _deleteProfile();
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: Colors.black12,
                elevation: 2,
              ),
              child: const Text(
                "ยกเลิกสมาชิก",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
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

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    ClipOval(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network(
                          _imageCtrl.text.isNotEmpty
                              ? _imageCtrl.text
                              : user!.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.purple.withOpacity(.1),
                            child: const Icon(
                              Icons.account_circle,
                              size: 120,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _fullnameCtrl,
                      decoration: const InputDecoration(
                        labelText: "ชื่อ-นามสกุล",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: "หมายเลขโทรศัพท์",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: "อีเมล",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _imageCtrl,
                      decoration: const InputDecoration(
                        labelText: "รูปภาพ (URL)",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}), // พรีวิวเปลี่ยนตาม URL
                    ),
                    const SizedBox(height: 24),

                    // ปุ่มบันทึกข้อมูล (ยืนยันก่อน)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saving
                            ? null
                            : () async {
                                final confirm = await _confirmUpdate();
                                if (confirm == true) {
                                  _updateProfile();
                                }
                              },
                        child: Text(
                          _saving ? "กำลังบันทึก..." : "บันทึกข้อมูล",
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Overlay โหลดระหว่างบันทึก
              if (_saving)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<bool?> _confirmUpdate() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("ยืนยันการบันทึก"),
        content: const Text("คุณต้องการบันทึกข้อมูลหรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("ยืนยันการลบ"),
        content: const Text("คุณต้องการยกเลิกสมาชิกหรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }
}
