import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/overview/overviewPage.dart';
import 'package:flutter_application_1/screens/week_reflectie/week_reflectie.dart';
import 'navbar.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection.dart';
import '../functions/log_controller.dart';
import '../functions/syncronisatie.dart';
import 'calendar/calendar.dart';
import 'overview/learningGoalOverview.dart';
import 'week_reflectie/week_reflectie.dart';

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  log_controller log = log_controller();
  //Start index of screen list
  int selectedIndex = 2;

  //List of all screens
  final List<Widget> screens = [
    // const learningGoalOverview(),
    const learningGoalOverview(),
    const learninggoalPage(),
    const calendarPage(),
    dailyReflectionPage(selectedDate: DateTime.now()),
    week_reflectie(selectedDate: DateTime.now())
  ];
  final List<String> screenNames = [
    "Overzicht",
    "Leerdoel",
    "Kalender",
    "Dagelijkse reflectie",
    "Week reflectie"
  ];

  //Function to switch index if navbar is touched
  void onClicked(int index) {
    syncWithDatabase();
    setState(() {
      selectedIndex = index;
    });
  }

  syncWithDatabase() async {
    await Syncronisation.syncUp();
  }

  Future<bool> _onBackPressed() async {
    onClicked(2);
    return false;
  }

  // Build Pagecontent, display content by index
  @override
  Widget build(BuildContext context) {
    log.record("Is naar pagina " + screenNames[selectedIndex] + " gegaan.");
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Center(child: screens[selectedIndex]),
          bottomNavigationBar: BottomMenu(
            selectedIndex: selectedIndex,
            onClicked: onClicked,
          ),
        ));
  }
}
