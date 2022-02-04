import 'package:flutter/material.dart';
import '../controllers/log_controller.dart';
import '../database_connection/syncronisatie.dart';
import 'navbar.dart';

//Import all screens
import 'daily_reflection/daily_reflection_screen.dart';
import 'calendar/calendar_screen.dart';
import 'overview/learningGoalOverview.dart';
import 'week_reflection/week_reflection_screen.dart';
import 'learning_goal/learning_goal_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  log_controller log = log_controller();
  int selectedIndex = 2;
  int selectedScreenIndex = 2;
  DateTime currentDateTime = DateTime.now();

  List<Widget> screens = [];

  final List<String> listOfScreenNames = [
    "Overzicht",
    "Leerdoel",
    "Kalender",
    "Dagelijkse reflectie",
    "Week reflectie",
    "Specifieke Dagelijkse reflectie",
  ];

  void builtScreens() {
    screens.add(const learningGoalOverview());
    screens.add(const LearningGoalScreen());
    screens.add(CalendarScreen(parent: this));
    screens.add(dailyReflectionPage(selectedDate: currentDateTime));
    screens.add(WeekReflectionScreen(selectedDate: currentDateTime));
    screens.add(dailyReflectionPage(selectedDate: currentDateTime));
  }

  void navigateToSelectedScreen(int index) {
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

  Future<bool> onPressReturnToHome() async {
    navigateToSelectedScreen(2);
    return false;
  }

  void redirectToDailyReflectionScreen(DateTime date) {
    setState(() {
      screens.remove(dailyReflectionPage(selectedDate: currentDateTime));
      currentDateTime = date;
      selectedIndex = 3;
      selectedScreenIndex = 5;
      builtScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    builtScreens();
    // Build Pagecontent, display content by index
    log.record("Is naar pagina " +
        listOfScreenNames[selectedScreenIndex] +
        " gegaan.");
    return WillPopScope(
        onWillPop: onPressReturnToHome,
        child: Scaffold(
          body: Center(child: screens[selectedScreenIndex]),
          bottomNavigationBar: BottomMenu(
            selectedIndex: selectedIndex,
            onClicked: navigateToSelectedScreen,
          ),
        ));
  }
}
