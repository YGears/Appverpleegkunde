import 'package:flutter/material.dart';
import 'package:app_verpleegkunde/screens/overview/leerdoelenView.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPage createState() => _OverviewPage();
}

class _OverviewPage extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overzicht'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(children: <Widget>[
          // Card(
          //   child: ListTile(
          //     title: const Text(
          //       'leerdoel',
          //     ),

          //          onTap: () {
          //           Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => const learningGoalOverview()));

          //          }
          //   ),

          // ),
          itembox(context, 'Leerdoelen', 0)
        ]),
      ),
    );
  }
}

void _navigateAndDisplaySelection(BuildContext context, int index) async {
  //List of all screens
  final List<Widget> pages = [
    learningGoalOverview(),
    //dagReflecties(),
    //weekReflecties(),
  ];

  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => pages[index]),
  );
}

//TEST
BoxDecoration borderStyling() {
  return BoxDecoration(
    color: Colors.orange[50],
    border: Border.all(width: 3.0),
    borderRadius: const BorderRadius.all(
        Radius.circular(10.0) //                 <--- border radius here
        ),
  );
}

//Widget for selecting a period in which that learning goal will be set
Widget itembox(BuildContext context, String type, int index) {
  return GestureDetector(
    onTap: () {
      _navigateAndDisplaySelection(context, index);
    },
    child: Container(
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        width: 300,
        height: 90,
        padding: const EdgeInsets.only(top: 28),
        decoration: borderStyling(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            type,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ])),
  );
}
