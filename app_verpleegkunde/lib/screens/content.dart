import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/overview/overviewPage.dart';
import 'navbar.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection.dart';
import 'calendar/calendar.dart';
import 'overview/leerdoelenView.dart';

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  //Start index of screen list
  int selectedIndex = 1;
  //List of all screens
  final List<Widget> screens = [
    // const learningGoalOverview(),
    const OverviewPage(),
    const calendarPage(),
    const learninggoalPage(),
    dailyReflectionPage(selectedDate: DateTime.now()),
  ];

  //Function to switch index if navbar is touched
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Build Pagecontent, display content by index
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: screens[selectedIndex]),
      bottomNavigationBar: BottomMenu(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
    );
  }
}
