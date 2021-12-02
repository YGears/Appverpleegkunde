// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);
  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hanze - Verpleegkunde',
        theme: ThemeData(
          //scaffoldBackgroundColor: const Color(0xFFe3e6e8),
          primarySwatch: Colors.orange,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            //Topheader within the application
            appBar: AppBar(
              title: const Text('Hanze Verpleegkunde'),
              centerTitle: true,
            ),
            // Body of the application
            body: Column(children: <Widget>[
              build_content(context),
            ]),
          ),
        ));
  }

  int _counter = 0;
  int tableWidth = 10;
  int count = 0;
  String blapi = "asf";
  var days_in_week = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  DateTime selectedDate = DateTime.parse("2021-09-03 10:00");

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build_content(BuildContext context) {
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
        blapi = "kliks: $blapi";
      });
    }

    dag() async {
      setState(() {
        count = count + 1;
        blapi = "kliks: $blapi";
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
              child: Text(days_in_week[i - 1],
                  style: const TextStyle(
                      color: Colors.black,
                      backgroundColor: Color(0xFFffdd00),
                      fontSize: 7)),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(5),
                  backgroundColor: const Color(0xFFffdd00))));
        } else {
          row.children!.add(const Text(""));
        }
      }
      generatedTableChildren.add(row);
    }

    var container = Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10, top: 300),
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
              flex: 2, // 20%
              child: TextButton(
                  onPressed: () => nextMonth(-1),
                  child: const Text("previous Month")),
            ),
            Expanded(
              flex: 6, // 60%
              child: TextButton(
                  onPressed: () => {}, child: Text("$monthName $year")),
            ),
            Expanded(
              flex: 2, // 20%
              child: TextButton(
                  onPressed: () => nextMonth(1),
                  child: const Text("next Month")),
            )
          ]),
          Table(
              defaultColumnWidth: const FlexColumnWidth(1),
              columnWidths: const {0: FlexColumnWidth(2)},
              children: generatedTableChildren),
        ]));

    return container;
  }
}
