import 'package:flutter/material.dart';

class ShowTripPage extends StatefulWidget {
  final int cid; // เพิ่ม parameter รับ customer ID

  const ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String selectedCategory = 'ทั้งหมด'; // เก็บหมวดหมู่ที่เลือก

  @override
  void initState() {
    super.initState();
    // สามารถใช้ widget.cid ในการโหลดข้อมูล trip ของลูกค้าคนนี้
    print('Customer ID: ${widget.cid}');
    loadTrips(); // เรียกฟังก์ชันโหลดข้อมูลทริป
  }

  void loadTrips() {
    // TODO: เรียก API เพื่อโหลดข้อมูลทริป
    // ใช้ widget.cid ในการดึงข้อมูลทริปของลูกค้าคนนี้
  }

  void filterTripsByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    // TODO: กรองข้อมูลทริปตามหมวดหมู่
    print('Filter trips by: $category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEFF),
      appBar: AppBar(
        title: const Text('รายการทริป'),
        backgroundColor: const Color(0xFFFDEEFF),
        elevation: 0,
        automaticallyImplyLeading:
            false, // ซ่อนปุ่ม back เพราะใช้ pushReplacement
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: ไปหน้าโปรไฟล์ของลูกค้า
              print('Customer ID: ${widget.cid}');
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            // Category Filter Buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 8,
                  children: [
                    _buildCategoryButton('ทั้งหมด'),
                    _buildCategoryButton('เอเชีย'),
                    _buildCategoryButton('ยุโรป'),
                    _buildCategoryButton('อาเซียน'),
                    _buildCategoryButton('ประเทศไทย'),
                  ],
                ),
              ),
            ),

            // Trip List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'หมวดหมู่: $selectedCategory',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TODO: แสดงรายการทริปจริง
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.flight_takeoff,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'กำลังโหลดทริป...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Customer ID: ${widget.cid}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'ทริป'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'สิ่งที่ชอบ',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        onTap: (index) {
          // TODO: จัดการการนำทาง
          print('Bottom nav tapped: $index');
        },
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
