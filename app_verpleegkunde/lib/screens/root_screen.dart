import 'package:flutter/material.dart';
import 'week_reflection/week_reflection_screen.dart';
import 'learning_goal/learning_goal_screen.dart';
import 'navbar.dart';

//Import all screens
import 'daily_reflection/daily_reflection.dart';
import '../logging/log_controller.dart';
import '../database_connection/syncronisatie.dart';
import 'calendar/calendar_screen.dart';
import 'overview/learningGoalOverview.dart';
import 'week_reflection/week_reflection_screen.dart';

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

  final List<Widget> screens = [
    // const learningGoalOverview(),
    const learningGoalOverview(),
    LearningGoalScreen(),
    const CalendarScreen(),
    dailyReflectionPage(selectedDate: DateTime.now()), //DUBBEL CHECK
    WeekReflectionScreen(selectedDate: DateTime.now()) //DUBBEL CHECK
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
    // Try to establisch a conaction to update user information
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