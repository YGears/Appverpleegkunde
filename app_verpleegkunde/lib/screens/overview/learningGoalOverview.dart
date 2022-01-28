import 'dart:async';
import 'dart:convert';
import '../../database_connection/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../style.dart';
import 'dailyReflectionOverview.dart';
import 'weeklyReflectionOverview.dart';

// ignore: camel_case_types
class learningGoalOverview extends StatefulWidget {
  const learningGoalOverview({Key? key}) : super(key: key);

  @override
  learningGoalOverviewState createState() => learningGoalOverviewState();
}

// ignore: camel_case_types
class learningGoalOverviewState extends State<learningGoalOverview> {
  List<Widget> generatedBody = [];
  bool justOnce = false;
  list_controller reflectionController = list_controller('daily_reflection');

  @override
  Widget build(BuildContext context) {
    getTags() async {
      final prefs = await SharedPreferences.getInstance();
      List<String>? leerdoelen = prefs.getStringList('leerdoel');
      return leerdoelen;
      // return "\"leerdoel\":[{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},]";
    }

    fillBody() async {
      List<String>? leerdoelen = await getTags();
      List<Widget> listToReturn = [];

      if (leerdoelen == null) {
        return;
      }

      for (String vari in leerdoelen) {
        Map<String, dynamic> decodedLearningGoals = jsonDecode(vari);
        String temp = decodedLearningGoals["eind_datum"];
        double gemiddelde = await get_average_score(
            formatDateTimes(decodedLearningGoals["begin_datum"]),
            formatDateTimes(decodedLearningGoals["eind_datum"]));
        

        print(decodedLearningGoals);
        listToReturn.add(Row(
          children: [
            itembox(
                context,
                decodedLearningGoals["begin_datum"],
                decodedLearningGoals["eind_datum"],
                decodedLearningGoals["onderwerp"],
                decodedLearningGoals["streefcijfer"],
                gemiddelde),
          ],
        ));
        listToReturn.add(const SizedBox(
          height: 10,
          width: 10,
        ));
      }
      setState(() {
        generatedBody = listToReturn;
      });
    }

    if (!justOnce) {
      print("wat");
      justOnce = true;
      fillBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Overzicht van leerdoelen"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      //body: Column(children: generatedBody));
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // padding: const EdgeInsets.only(top: 10.0),
                itemCount: generatedBody.length,
                itemBuilder: (context, index) {
                  return generatedBody[index];
                }),
          ],
        ),
      ),
    );
  }

  //Widget for selecting a period in which that learning goal will be set
  Widget itembox(BuildContext context, String startDate, String endDate,
      String onderwerp, String streefcijfer, double gemiddelde) {
        if(gemiddelde.isNaN){gemiddelde = 0;}
    return Container(
        // margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        width: 300,
        // padding: const EdgeInsets.all(10.0),
        decoration: Style().borderStyling(),
        child: Column(children: [
          Text(
            onderwerp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Creates spacing between items inside of the column
          const SizedBox(
            height: 8,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$startDate - $endDate'),
                    const SizedBox(
                      width: 20,
                      height: 10,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Streefcijfer: $streefcijfer/10"),
                    const SizedBox(width: 20),
                    Text("Gemiddelde: " + gemiddelde.toStringAsFixed(2) + "/10")
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          _navigateAndDisplaySelection(context, 0, onderwerp, startDate, endDate);
                        },
                        child: const Text(
                          'Dagreflecties',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _navigateAndDisplaySelection(context, 1, onderwerp, startDate, endDate);
                        },
                        child: const Text(
                          'Weekreflecties',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ])
              ])
        ]));
  }

  Future<double> get_average_score(DateTime start, DateTime end) async {
    List<dynamic> reflections = await reflectionController.getList;
    double gemCijfer = 0;
    double amountOfReflections = 0;

    for (var entry in reflections) {
      if (entry != null) {
        var decodedEntry = json.decode(entry);
        if (start.difference(DateTime.parse(decodedEntry["datum"])).inHours <
                0 &&
            end.difference(DateTime.parse(decodedEntry["datum"])).inHours >
                0) {
          gemCijfer += decodedEntry["rating"] as double;
          amountOfReflections += 1;
        }
      }
    }
    return gemCijfer/amountOfReflections;
  }

  DateTime formatDateTimes(String datum) {
    List<String> gesplitst = datum.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
    DateTime result = DateTime.parse(reassemble);
    return result;
  }
  void _navigateAndDisplaySelection(BuildContext context, int index, String onderwerp, String startdate, String enddate) async {
  //List of all screens
  List<String> learninggoal = [onderwerp, startdate, enddate];
  final List<Widget> pages = [
    dailyReflectionOverview(learninggoal),
    weeklyReflectionOverview(learninggoal),
  ];

  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => pages[index]),
  );
}
}
