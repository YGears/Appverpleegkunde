import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
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
          backgroundColor: Colors.black,
          label: "Resultaten",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.mode),
          label: "Zet doel",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Dagreflectie",
        )
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: Colors.red[800],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    );
  }
}
