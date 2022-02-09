// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import '../learning_goal/learning_goal.dart';

import '../../controllers/list_controller.dart';
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
  ListController reflectionController = ListController('daily_reflection');

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
        LearningGoal decodedLearningGoals =
            LearningGoal.fromJson(jsonDecode(vari));
        double gemiddelde = await getAverageScore(
            decodedLearningGoals.getBeginingDate,
            decodedLearningGoals.getEndingDate);

        listToReturn.add(Row(
          children: [
            itembox(context, decodedLearningGoals, gemiddelde),
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
  Widget itembox(
      BuildContext context, LearningGoal learningGoal, double gemiddelde) {
    if (gemiddelde.isNaN) {
      gemiddelde = 0;
    }
    var onderwerp = learningGoal.getSubject;
    var startDate = learningGoal.getBeginingDate.toString().substring(0, 10);
    var endDate = learningGoal.getEndingDate.toString().substring(0, 10);
    var streefcijfer = learningGoal.getTargetGrade.toString();
    return Container(
        width: 300,
        decoration: Style().defaultBoxStyling(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                          navigateAndDisplaySelection(context, 0, learningGoal);
                        },
                        child: const Text(
                          'Dagreflecties',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          null;
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

  Future<double> getAverageScore(DateTime start, DateTime end) async {
    List<dynamic> reflections = await reflectionController.getList;
    double gemCijfer = 0;
    double amountOfReflections = 0;

    for (String entryString in reflections) {
      DailyReflection entry = DailyReflection.fromJson(jsonDecode(entryString));
      if (start.difference(entry.getDateType).inHours <= 0 &&
          end.difference(entry.getDateType).inHours >= 0) {
        gemCijfer += entry.getRating;
        amountOfReflections += 1;
      }
    }
    return gemCijfer / amountOfReflections;
  }

  DateTime formatDateTimes(String date) {
    //Convert date to format nessery for json db
    List<String> seperated = date.split('/');
    if (seperated[1].length < 2) {
      seperated[1] = '0' + seperated[1];
    }
    if (seperated[0].length < 2) {
      seperated[0] = '0' + seperated[0];
    }

    String reassemble = seperated[2] + seperated[1] + seperated[0];
    DateTime result = DateTime.parse(reassemble);
    return result;
  }

  void navigateAndDisplaySelection(
      BuildContext context, int index, LearningGoal learninggoal) async {
    //List of all screens
    final List<Widget> pages = [
      dailyReflectionOverview(learninggoal),
      WeeklyReflectionOverview(const ["onderwerp", "startdate", "enddate"]),
    ];

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pages[index]),
    );
  }
}
