import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navbar.dart';
import 'template_tmp.dart';

//Import all screens
import 'learning_goal/learning_goal.dart';
import 'daily_reflection/daily_reflection.dart';
import 'main/main.dart';
import 'overview/overview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Start index of screen list
  int selectedIndex = 1;
  //List of all screens
  final List<Widget> screens = [
    const Overview(),
    const mainPage(),
    const Leerdoel(),
    dailyReflectionPage(selectedDate: DateTime.now()),
  ];
  //Function to switch index if navbar is touched
  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hanze Verpleeg App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFe3e6e8),
        primarySwatch: Colors.orange,
      ),
      home: Builder(
          builder: (context) => Scaffold(
              //body: Center(child: build_content(context)),
              body: Center(child: screens[selectedIndex]),
              bottomNavigationBar: BottomMenu(
                selectedIndex: selectedIndex,
                onClicked: onClicked,
              ))),
    );
  }
}
