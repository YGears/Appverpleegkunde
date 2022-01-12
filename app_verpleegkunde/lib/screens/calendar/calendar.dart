// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class calendarPage extends StatefulWidget {
  const calendarPage({Key? key}) : super(key: key);
  @override
  State<calendarPage> createState() => _calendarPageState();
}

class _calendarPageState extends State<calendarPage> {
  int tableWidth = 10;
  int count = 0;
  var daysInWeek = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"];
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    'Januari',
    'Februari',
    'Maart',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Augustus',
    'September',
    'Oktober',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      //Topheader within the application
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      // Body of the application
      body: content(context),
    );
  }

  Widget calendarHeader(BuildContext context) {
    return Container();
  }

  Widget calendar(BuildContext context) {
    return Container();
  }

  Widget content(BuildContext context) {
    var year = selectedDate.year;
    var month = selectedDate.month;
    var day = selectedDate.day;
    var firstMonday = DateTime(year, month, 1);
    var lastDay = 0;
    var generatedTableChildren = <TableRow>[];
    var monthName = months[selectedDate.month - 1];

    _week() async {
      setState(() {
        count = count + 1;
      });
    }

    dag() async {
      setState(() {
        count = count + 1;
      });
    }

    nextMonth(increment) {
      setState(() {
        var new_month = month + increment;
        if (new_month < 10) {
          selectedDate = DateTime.parse("$year-0$new_month-01 00:00:00");
        } else {
          selectedDate = DateTime.parse("$year-$new_month-01 00:00:00");
        }
      });
    }

    for (int week = 1; week < 6; week++) {
      var row = TableRow(children: [
        ElevatedButton(
          onPressed: () {
            _week();
          },
          child: Text("Week$week"),
        ),
        const Text(
          "",
          style: TextStyle(color: Colors.black, fontSize: 9),
        )
      ]);

      for (var i = 1; i < 8; i++) {
        var check = DateTime(year, month + 1, 0).day;
        if ((i >= firstMonday.weekday || week - 1 > 0) &&
            DateTime(year, month + 1, 0).day >=
                i + (week - 1) * 7 - firstMonday.weekday) {
          row.children!.add(TextButton(
              onPressed: () {
                dag();
              },
              child: Text(daysInWeek[i - 1],
                  style: const TextStyle(
                      color: Colors.black,
                      backgroundColor: Color(0xFFffdd00),
                      fontSize: 7)),
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                  backgroundColor: const Color(0xFFffdd00))));
        } else {
          row.children!.add(const Text(""));
        }
      }
      generatedTableChildren.add(row);
    }

    var container = Container(
        child: Column(children: [
      Container(
        child: Row(children: <Widget>[
          const Spacer(flex: 2),
          Expanded(
            flex: 2, // 20%
            child: TextButton(
                onPressed: () => nextMonth(-1),
                child: const Icon(Icons.navigate_before)),
          ),
          Expanded(
            flex: 4, // 60%
            child: TextButton(
                onPressed: () => {}, child: Text("$monthName $year")),
          ),
          Expanded(
            flex: 2, // 20%
            child: TextButton(
              onPressed: () => nextMonth(1),
              child: const Icon(Icons.navigate_next),
            ),
          ),
          const Spacer(flex: 2),
        ]),
      ),
      Table(
          defaultColumnWidth: const FlexColumnWidth(1),
          columnWidths: const {0: FlexColumnWidth(2)},
          children: generatedTableChildren),
    ]));

    return container;
  }
}
