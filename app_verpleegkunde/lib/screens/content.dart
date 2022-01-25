import 'package:flutter/material.dart';
import '../screens/week_reflection/weekReflection.dart';
import 'navbar.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection.dart';
import '../functions/log_controller.dart';
import '../functions/syncronisatie.dart';
import 'calendar/calendar.dart';
import 'overview/learningGoalOverview.dart';
import 'week_reflection/weekReflection.dart';

// ignore: camel_case_types
class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreen();
}

class _RootScreen extends State<RootScreen> {
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

  void onClicked(int index) {
    //Function to switch index if navbar is touched
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

  @override
  Widget build(BuildContext context) {
    // Build Pagecontent, display content by index
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
