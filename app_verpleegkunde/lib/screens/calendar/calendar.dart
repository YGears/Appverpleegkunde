// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget content(BuildContext context) {
    var year = selectedDate.year;
    var month = selectedDate.month;
    var week = selectedDate.weekday;
    var firstMonday = DateTime(year, month, 1);
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

    nextWeek(increment) {
      setState(() {
        var week1 = week + increment;
      });
    }

    /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
    int numOfWeeks(int year) {
      DateTime dec28 = DateTime(year, 12, 28);
      int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
      return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
    }

    /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
    int weekNumber(DateTime date) {
      int dayOfYear = int.parse(DateFormat("D").format(date));
      int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
      if (woy < 1) {
        woy = numOfWeeks(date.year - 1);
      } else if (woy > numOfWeeks(date.year)) {
        woy = 1;
      }
      return woy;
    }

    // Fill a list witch contains all weeksNumbers of a given month in a given year
    List listOfWeeks(year, month) {
      int lastDayOfMonth = DateTime(year, month + 1, 0).day;
      var weeknrs = [];
      int mondayOffset = (DateTime(year, month, 1).weekday - 1 - 8) * -1;

      weeknrs.add(weekNumber(DateTime(year, month, 1)));

      while (mondayOffset <= lastDayOfMonth) {
        weeknrs.add(weekNumber(DateTime(year, month, mondayOffset)));
        mondayOffset += 7;
      }

      print(weeknrs);
      return weeknrs;
    }

    generateCalendar() {
      var testing = listOfWeeks(year, month);
      for (var week in testing) {
        var weeks = listOfWeeks(year, month);
        var row = TableRow(children: [
          Text(week.toString()),
          const Text(
            "",
            style: TextStyle(color: Colors.black, fontSize: 9),
          )
        ]);

        for (var i = 1; i < 8; i++) {
          if ((i >= firstMonday.weekday || week - 1 > 0) &&
              DateTime(year, month + 1, 0).day >=
                  i + (week - 1) * 7 - firstMonday.weekday) {
            row.children!.add(TextButton(
                onPressed: () {
                  dag();
                },
                child: Text(i.toString(),
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
          print(firstMonday.weekday);
        }
        generatedTableChildren.add(row);
      }
    }

    generateCalendar();

    var container = Container(
        child: Column(children: [
      Row(children: <Widget>[
        const Spacer(flex: 2),
        Expanded(
          flex: 2, // 20%
          child: TextButton(
              onPressed: () => nextMonth(-1),
              child: const Icon(Icons.navigate_before)),
        ),
        Expanded(
          flex: 4, // 60%
          child:
              TextButton(onPressed: () => {}, child: Text("$monthName $year")),
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
      Row(children: const <Widget>[
        Expanded(
            flex: 2, // 20%
            child: Text("Week")),
        Spacer(flex: 1),
        Expanded(
            flex: 1, // 20%
            child: Text("Ma")),
        Expanded(
            flex: 1, // 20%
            child: Text("Di")),
        Expanded(
            flex: 1, // 20%
            child: Text("Wo")),
        Expanded(
            flex: 1, // 20%
            child: Text("Do")),
        Expanded(
            flex: 1, // 20%
            child: Text("Vr")),
        Expanded(
            flex: 1, // 20%
            child: Text("Za")),
        Expanded(
            flex: 1, // 20%
            child: Text("Zo")),
      ]),
      Table(
          defaultColumnWidth: const FlexColumnWidth(1),
          columnWidths: const {0: FlexColumnWidth(2)},
          children: generatedTableChildren),
    ]));
    print("NEW :");
    //var weekz = listOfWeeks(year, month);
    //print(weekz.length);
    //print(weekz);
    return container;
  }
}
