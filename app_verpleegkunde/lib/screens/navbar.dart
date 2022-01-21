import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // List of icons : https://api.flutter.dev/flutter/material/Icons-class.html
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Resultaten",
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.mode),
          label: "Zet doel",
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: "Dagreflectie",
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Weekreflectie",
          backgroundColor: Colors.black,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: Colors.orange[800],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    );
  }
}
