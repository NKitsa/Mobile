import 'package:flutter/material.dart';

class ShowTripPage extends StatefulWidget {
  const ShowTripPage({super.key});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายการทริป')),
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 2,
                children: [
                  FilledButton(onPressed: () {}, child: Text('ทั้งหมด')),
                  FilledButton(onPressed: () {}, child: Text('เอเชีย')),
                  FilledButton(onPressed: () {}, child: Text('ยุโรป')),
                  FilledButton(onPressed: () {}, child: Text('อาเซียน')),
                  FilledButton(onPressed: () {}, child: Text('ประเทศ')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
