import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/req/res/res_showdetail_trip.dart';

class ShowDetailTripPage extends StatefulWidget {
  final int idx;
  const ShowDetailTripPage({super.key, required this.idx});

  @override
  State<ShowDetailTripPage> createState() => _ShowDetailTripPageState();
}

class _ShowDetailTripPageState extends State<ShowDetailTripPage> {
  TripDetailRes? detail;
  late Future<void> loadData;
  String url = '';

  @override
  void initState() {
    super.initState();
    // โหลด config ก่อน แล้วค่อยดึงข้อมูล
    loadData = Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      return _loadDetail();
    });
  }

  Future<void> _loadDetail() async {
    final endpoint = '$url/trips/${widget.idx}'; // ✅ ใช้จาก config
    log('GET $endpoint');

    final res = await http.get(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      detail = tripDetailResFromJson(res.body);
    } else {
      throw Exception('โหลดรายละเอียดล้มเหลว: ${res.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดทริป')),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }
          if (detail == null) {
            return const Center(child: Text('ไม่พบข้อมูล'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail!.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  detail!.country,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    detail!.coverimage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 56),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ราคา: ${detail!.price} บาท',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('ระยะเวลา: ${detail!.duration} วัน'),
                const SizedBox(height: 8),
                Text('โซน: ${detail!.destinationZone}'),
                const SizedBox(height: 16),
                const Text(
                  'รายละเอียด',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(detail!.detail),
              ],
            ),
          );
        },
      ),
    );
  }
}
