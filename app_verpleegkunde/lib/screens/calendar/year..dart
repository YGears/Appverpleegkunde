import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Year extends StatelessWidget {
  Year({Key? key}) : super(key: key);

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

  int numOfWeeks(int year) {
    /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int weekNumber(DateTime date) {
    /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  List listOfWeeks(year, month) {
    // Fill a list witch contains all weeksNumbers of a given month in a given year
    // Integer that holds the last day of given month in  a given year
    int lastcurrentDayInMonth = DateTime(year, month + 1, 0).day;
    // -1 is gap between days, -8 is gap(-8 start)*-1 get positive number
    int mondayOffset = (DateTime(year, month, 1).weekday - 1 - 8) * -1;
    var listOfWeekNumb = [];
    listOfWeekNumb.add(weekNumber(DateTime(year, month, 1)));
    // Add weeknumber of the every monday of a given month in a given year, starting with the first monday
    // Increase this by a week (7 days) until this number becomes higher that the lenght of the month, than stop
    while (mondayOffset <= lastcurrentDayInMonth) {
      listOfWeekNumb.add(weekNumber(DateTime(year, month, mondayOffset)));
      mondayOffset += 7;
    }
    return listOfWeekNumb;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
