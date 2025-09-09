import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  final int cid; // Customer ID

  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String selectedCategory = 'ทั้งหมด';
  List<dynamic> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    try {
      final res = await http.get(Uri.parse('http://192.168.1.105:3000/trips'));
      if (res.statusCode == 200) {
        setState(() {
          trips = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('โหลด trips ล้มเหลว: ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void filterTripsByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEFF),
      appBar: AppBar(
        title: const Text('รายการทริป'),
        backgroundColor: const Color(0xFFFDEEFF),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('Customer ID: ${widget.cid}');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ปุ่ม filter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryButton('ทั้งหมด'),
                  const SizedBox(width: 8),
                  _buildCategoryButton('เอเชีย'),
                  const SizedBox(width: 8),
                  _buildCategoryButton('ยุโรป'),
                  const SizedBox(width: 8),
                  _buildCategoryButton('อาเซียน'),
                  const SizedBox(width: 8),
                  _buildCategoryButton('ประเทศไทย'),
                ],
              ),
            ),
          ),

          // Trip List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // รูปภาพ
                            if (trip['coverimage'] != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  trip['coverimage'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    height: 180,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip['name'] ?? 'ไม่มีชื่อทริป',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    trip['country'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "ระยะเวลา ${trip['duration']} วัน",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "ราคา ${trip['price']} บาท",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // ไปหน้า detail
                                        print('ดูรายละเอียด ${trip['name']}');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                      ),
                                      child: const Text("รายละเอียดเพิ่มเติม"),
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
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;

    return FilledButton(
      onPressed: () => filterTripsByCategory(category),
      style: FilledButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(category),
    );
  }
}
