import 'package:flutter/material.dart';
import 'week_reflection/week_reflection_screen.dart';
import 'learning_goal/learning_goal_screen.dart';
import 'navbar.dart';

//Import all screens
import 'daily_reflection/daily_reflection_screen.dart';
import '../controllers/log_controller.dart';
import '../database_connection/syncronisatie.dart';
import 'calendar/calendar_screen.dart';
import 'overview/learningGoalOverview.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreen();
}

class _RootScreen extends State<RootScreen> {
  LogController log = LogController();
  //Start index of screen list
  int selectedIndex = 2;
  var selectedScreenIndex = 2;
  var customDate = DateTime.now();

  List<Widget> screens = [];

  final List<String> screenNames = [
    "Overzicht",
    "Leerdoel",
    "Kalender",
    "Dagelijkse reflectie",
    "Week reflectie",
    "Specifieke Dagelijkse reflectie",
  ];

  void builtScreens() {
    screens = [];
    screens.add(learningGoalOverview());
    screens.add(LearningGoalScreen());
    screens.add(CalendarScreen(parent: this));
    screens.add(dailyReflectionPage(selectedDate: DateTime.now()));
    screens
        .add(WeekReflectionScreen(selectedDate: DateTime.now())); //DUBBEL CHECK
    screens.add(dailyReflectionPage(selectedDate: customDate));
  }

  void onClicked(int index) {
    //Function to switch index if navbar is touched
    syncWithDatabase();
    setState(() {
      selectedIndex = index;
      selectedScreenIndex = index;
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

  void gotoDailyReflection(DateTime date) {
    setState(() {
      screens.remove(dailyReflectionPage(selectedDate: customDate));
      customDate = date;
      selectedIndex = 3;
      selectedScreenIndex = 5; //index of the dailyreflection with custom date
      builtScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    builtScreens();
    // Build Pagecontent, display content by index
    log.record(
        "Is naar pagina " + screenNames[selectedScreenIndex] + " gegaan.");
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Center(child: screens[selectedScreenIndex]),
          bottomNavigationBar: BottomMenu(
            selectedIndex: selectedIndex,
            onClicked: onClicked,
          ),
        ));
  }
}
