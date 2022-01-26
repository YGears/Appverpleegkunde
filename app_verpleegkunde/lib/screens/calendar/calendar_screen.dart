import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_colors.dart';
import 'calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key, required this.parent}) : super(key: key);
  final parent;
  @override
  State<CalendarScreen> createState() => _CalendarScreenState(parent);
}

class _CalendarScreenState extends State<CalendarScreen> {
  var par;
  _CalendarScreenState(newParent){
    par = newParent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: Calendar(parent: par),
    );
  }
}
