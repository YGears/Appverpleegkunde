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
  //List of all screens
  final List<Widget> screens = [
    // const learningGoalOverview(),
    const learningGoalOverview(),
    const calendarPage(),
    const learninggoalPage(),
    dailyReflectionPage(selectedDate: DateTime.now()),
  ];
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
    });
  }

  syncWithDatabase() async{
    await Syncronisation.syncUp();
  }
  Future<bool> _onBackPressed() async{
    onClicked(1);
    return false;
  }
  
  void get_average_score(DateTime start, DateTime end)async{

    var daily_reflection_controller = list_controller("daily_reflection");
    List<dynamic> reflections = await daily_reflection_controller.getList;
    var gem_cijfer = 0;
    var amount_of_reflections = 0;

    for(var entry in reflections){
      if (entry != null){
        print("lol");
        var decoded_entry = json.decode(entry);
        if (
          start.difference(DateTime.parse(decoded_entry["datum"])).inHours < 0 &&
          end.difference(DateTime.parse(decoded_entry["datum"])).inHours > 0 
        ){
          gem_cijfer += decoded_entry["rating"] as int;     
          // gem_cijfer += 2; 
          amount_of_reflections += 1;             
        }
        // print(gem_cijfer);
      }
    }
    print(amount_of_reflections);
    print(gem_cijfer / amount_of_reflections);
  }
  
  // Build Pagecontent, display content by index
  @override
  Widget build(BuildContext context) {
    
    get_average_score(DateTime(2022, 1, 24), DateTime(2022,1,36));
    // Syncronisation.send_log_data();

    log.record("Is naar pagina " + screenNames[selectedIndex] + " gegaan.");
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        body: Center(child: screens[selectedIndex]),
        bottomNavigationBar: BottomMenu(
          selectedIndex: selectedIndex,
          onClicked: onClicked,
        ),
      )
    );
  }
}
