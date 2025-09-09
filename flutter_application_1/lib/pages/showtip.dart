import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/pages/showdetail_trip.dart';
import 'package:flutter_application_1/pages/profile.dart';

// โมเดล TripRes และฟังก์ชัน tripResFromJson ต้องมีในไฟล์นี้
import 'package:flutter_application_1/model/req/res/res_showtip.dart';

class ShowTripPage extends StatefulWidget {
  final int cid;

  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  List<TripRes> allTrips = []; // เก็บข้อมูลทริปทั้งหมด
  List<TripRes> filteredTrips = []; // เก็บข้อมูลที่ถูกกรอง
  late Future<void> loadData;
  bool isLoading = false;
  String url = '';

  @override
  void initState() {
    super.initState();
    // โหลด config ก่อนแล้วค่อยดึงข้อมูลจาก API
    loadData = Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      return loadDataAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    log('cid=${widget.cid}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'profile', child: Text('โปรไฟล์')),
              PopupMenuItem(value: 'logout', child: Text('ออกจากระบบ')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loadData = loadDataAsync();
                      });
                    },
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'ปลายทาง',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // ปุ่ม filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    FilterButton(
                      text: 'ทั้งหมด',
                      onPressed: () => filterTrips(null),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 10),
                    FilterButton(
                      text: 'เอเชีย',
                      onPressed: () => filterTrips('เอเชีย'),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 10),
                    FilterButton(
                      text: 'ยุโรป',
                      onPressed: () => filterTrips('ยุโรป'),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 10),
                    FilterButton(
                      text: 'อาเซียน',
                      onPressed: () => filterTrips('อาเซียน'),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 10),
                    FilterButton(
                      text: 'ประเทศไทย',
                      onPressed: () => filterTrips('ประเทศไทย'),
                      isLoading: isLoading,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Trip list
              Expanded(
                child: filteredTrips.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่พบข้อมูลทริป',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTrips.length,
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: Image.network(
                                    trip.coverimage,
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'ปลายทาง: ${trip.destinationZone}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'ราคา: ${_fmtPrice(trip.price)} บาท',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ShowDetailTripPage(
                                                      idx: trip.idx,
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.info_outline),
                                          label: const Text('รายละเอียด'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ฟิลเตอร์รายการตาม destination_zone
  void filterTrips(String? zone) {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        if (zone == null) {
          filteredTrips = List.from(allTrips);
        } else {
          filteredTrips = allTrips
              .where((trip) => (trip.destinationZone).trim() == zone)
              .toList();
        }
        isLoading = false;
      });
    });
  }

  /// โหลดข้อมูลจาก API
  Future<void> loadDataAsync() async {
    try {
      final endpoint = '$url/trips'; 
      log('GET $endpoint');

      final res = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      log('Status: ${res.statusCode}');
      if (res.statusCode == 200) {
        allTrips = tripResFromJson(res.body);
        filteredTrips = List.from(allTrips);
        log('Loaded trips: ${allTrips.length}');
      } else {
        throw Exception('Failed to load trips: ${res.statusCode} ${res.body}');
      }
    } catch (error) {
      log('Error loading trips: $error');
      rethrow;
    }
  }

  /// แสดงราคาแบบมีคอมม่า
  String _fmtPrice(num price) {
    final s = price.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final rev = s.length - i;
      buf.write(s[i]);
      if (rev > 1 && rev % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}

// ปุ่มกรอง
class FilterButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const FilterButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: Text(text),
    );
  }
}
