import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/overview/overviewPage.dart';
import 'navbar.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection_screen.dart';
import '../functions/list_controller.dart';
import '../functions/log_controller.dart';
import '../functions/syncronisatie.dart';
import 'calendar/calendar.dart';
import 'dart:convert';
import 'overview/leerdoelenView.dart';

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  log_controller log = log_controller();
  //Start index of screen list
  int selectedIndex = 1;
  var selectedScreenIndex = 1;
  //List of all screens
  List<Widget> screens = [];
  var customDate = DateTime.now();
  final List<String> screenNames = [
    "overview",
    "kalender",
    "leerdoel",
    "dagelijkse reflectie"
  ];

  //Function to switch index if navbar is touched
  void onClicked(int index) {
    syncWithDatabase();
    setState(() {
      selectedIndex = index;
      selectedScreenIndex = index;
    });
  }

  syncWithDatabase() async{
    await Syncronisation.syncUp();
  }
  Future<bool> _onBackPressed() async{
    onClicked(1);
    return false;
  }
  
  void builtScreens(){
    screens = [];
    screens.add(OverviewPage());
    screens.add(calendarPage(parent:this));
    screens.add(learninggoalPage());
    screens.add(dailyReflectionPage(selectedDate: DateTime.now()));
    screens.add(dailyReflectionPage(selectedDate: customDate));
  }
  
  void gotoDailyReflection(DateTime date) {
    setState(() {
      screens.remove(dailyReflectionPage(selectedDate: customDate));
      customDate = date;
      selectedIndex = 3;
      selectedScreenIndex = 4;
      builtScreens();
      print(screens.length);
    });
  }
  
  
  // Build Pagecontent, display content by index
  @override
  Widget build(BuildContext context) {
    builtScreens();
    // Syncronisation.send_log_data();

    log.record("Is naar pagina " + screenNames[selectedIndex] + " gegaan.");
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        body: Center(child: screens[selectedScreenIndex]),
        bottomNavigationBar: BottomMenu(
          selectedIndex: selectedIndex,
          onClicked: onClicked,
        ),
      )
    );
  }
}
