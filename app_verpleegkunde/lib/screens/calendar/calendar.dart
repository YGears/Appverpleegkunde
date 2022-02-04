import 'package:flutter/material.dart';
import 'year.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.parent}) : super(key: key);
  final parent; //Andere naam
  @override
  State<Calendar> createState() => CalendarState(parent); //Andere naam
}

class CalendarState extends State<Calendar> {
  int tableWidth = 10;
  int count = 0;
  var parent; //Andere naam
  List daysInWeek = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"];
  DateTime selectedDate = DateTime.now();

  CalendarState(var newParent) {
    //Andere naam
    this.parent = newParent; //Andere naam
  }

  @override
  Widget build(BuildContext context) {
    int year = selectedDate.year;
    int month = selectedDate.month;
    var calendarTable = <TableRow>[];
    String monthName = Year().months[selectedDate.month - 1];

    syncWithDatabase() async {
      //wat
      // await Syncronisation.syncUp();
    }

    goToSelectedDailyRefelection(var day) async {
      parent.redirectToDailyReflectionScreen(day);
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
      List weekNumsInMonth = Year().listOfWeeks(year, month);
      // Create x rows based on length of a given month in a given
      // Than for every row, give a week children if day is in week
      for (int week = 0; week < weekNumsInMonth.length; week++) {
        var calendarRow = TableRow(children: [
          Text(weekNumsInMonth[week].toString()),
          const Text(
            "",
            style: TextStyle(color: Colors.black, fontSize: 9),
          )
        ]);

        //DAG ITEMS IN DEZE WEEK
        for (int day = 1; day < 8; day++) {
          // COMPLEX IF STATEMENT EXPLAINATION
          if ((week == 0 && day < DateTime(year, month, 1).weekday) ||
              (week == (weekNumsInMonth.length - 1) &&
                  currentDayInMonth >= DateTime(year, month + 1, 0).day)) {
            calendarRow.children!.add(const Text(""));
          } else {
            currentDayInMonth++;
            var currentDay = DateTime(year, month, currentDayInMonth);
            calendarRow.children!.add(TextButton(
                onPressed: () => goToSelectedDailyRefelection(currentDay),
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
      Row(
        children: const [Text("")],
      ),
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
      Row(
        children: const [Text("")],
      ),
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
      Row(
        children: const [Text("")],
      ),
      Table(
          defaultColumnWidth: const FlexColumnWidth(1),
          columnWidths: const {0: FlexColumnWidth(2)},
          children: calendarTable),
    ]);
  }
}
