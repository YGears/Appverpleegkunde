import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_connection/syncronisatie.dart';
import 'date.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.parent}) : super(key: key);
  final parent;
  @override
  State<Calendar> createState() => _CalendarState(parent);
}

class _CalendarState extends State<Calendar> {
  int tableWidth = 10;
  int count = 0;
  var parent;
  var daysInWeek = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"];
  DateTime selectedDate = DateTime.now();

  _CalendarState(var newParent) {
    this.parent = newParent;
  }

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
    var year = selectedDate.year;
    var month = selectedDate.month;
    var calendarTable = <TableRow>[];
    var monthName = months[selectedDate.month - 1];

    syncWithDatabase() async {
      await Syncronisation.syncUp();
    }

    dag() async {
      setState(() {
        count = count + 1;
      });
    }

    specifiekeDagReflectie(var dag) async {
      // print(dadayteS);
      parent.gotoDailyReflection(dag);
    }

    nextMonth(increment) {
      setState(() {
        var newMonth = month + increment;
        if (newMonth < 10) {
          selectedDate = DateTime.parse("$year-0$newMonth-01 00:00:00");
        } else {
          selectedDate = DateTime.parse("$year-$newMonth-01 00:00:00");
        }
      });
    }

    createCalendar() {
      int currentDayInMonth = 0;
      var weekNumsInMonth = Date().listOfWeeks(year, month);
      // Create x rows based on length of a given month in a given
      // Than for every row, give a week children if day is in week
      for (var week = 0; week < weekNumsInMonth.length; week++) {
        var calendarRow = TableRow(children: [
          Text(weekNumsInMonth[week].toString()),
          const Text(
            "",
            style: TextStyle(color: Colors.black, fontSize: 9),
          )
        ]);

        //DAG ITEMS IN DEZE WEEK
        for (var day = 1; day < 8; day++) {
          // COMPLEX IF STATEMENT EXPLAINATION
          if ((week == 0 && day < DateTime(year, month, 1).weekday) ||
              (week == (weekNumsInMonth.length - 1) &&
                  currentDayInMonth >= DateTime(year, month + 1, 0).day)) {
            calendarRow.children!.add(const Text(""));
          } else {
            currentDayInMonth++;
            var dag = DateTime(year, month, currentDayInMonth);
            calendarRow.children!.add(TextButton(
                onPressed: () => specifiekeDagReflectie(dag),
                child: Text(currentDayInMonth.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        backgroundColor: Color(0xFFffdd00),
                        fontSize: 7)),
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    backgroundColor: const Color(0xFFffdd00))));
          }
        }
        calendarTable.add(calendarRow);
      }
    }

    createCalendar();
    syncWithDatabase();
    return Column(children: [
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
          children: calendarTable),
    ]);
  }
}
