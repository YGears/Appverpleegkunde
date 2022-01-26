import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_colors.dart';
import 'calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: const Calendar(),
    );
  }
}
