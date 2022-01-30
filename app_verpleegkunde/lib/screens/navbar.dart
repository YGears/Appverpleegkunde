import 'package:flutter/material.dart';
import '../app_colors.dart';

class BottomMenu extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({Key? key, this.selectedIndex, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "Overzicht",
          backgroundColor: navbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mode),
          label: "Zet doel",
          backgroundColor: navbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          backgroundColor: navbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: "Dagreflectie",
          backgroundColor: navbarColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Weekreflectie",
          backgroundColor: navbarColor,
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: selectedItemColor,
      backgroundColor: navbarColor,
      unselectedItemColor: unselectedItemColor,
    );
  }
}
