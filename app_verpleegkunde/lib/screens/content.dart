import 'package:flutter/material.dart';
import 'navbar.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection.dart';
import '../../functions/syncronisatie.dart';
import 'calendar/calendar.dart';
import 'overview/overview.dart';

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
    const learningGoalOverview(),
    const calendarPage(),
    const learninggoalPage(),
    dailyReflectionPage(selectedDate: DateTime.now()),
  ];

  //Function to switch index if navbar is touched
  void onClicked(int index) {
    syncWithDatabase();
    setState(() {
      selectedIndex = index;
    });
  }

  syncWithDatabase() async{
    await Syncronisation.syncUp();
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