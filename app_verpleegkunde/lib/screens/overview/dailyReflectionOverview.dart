import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_connection/api.dart';
import '../../controllers/log_controller.dart';
import '../../controllers/list_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../style.dart';

class dailyReflectionOverview extends StatefulWidget {
  var selectedLearningGoal;

  dailyReflectionOverview(LearningGoal learninggoal, {Key? key})
      : super(key: key) {
    selectedLearningGoal = learninggoal;
  }

  @override
  dailyReflectionOverviewState createState() =>
      dailyReflectionOverviewState(selectedLearningGoal);
}

class dailyReflectionOverviewState extends State<dailyReflectionOverview> {
  log_controller log = log_controller();
  list_controller reflectionController = list_controller('daily_reflection');
  bool justOnce = false;
  List<dynamic> generatedBody = [];

  var learninggoalSubject;
  dailyReflectionOverviewState(learninggoal) {
    learninggoalSubject = learninggoal;
  }

  @override
  Widget build(BuildContext context) {
    log.record("Is naar de kies leerdoel pagina gegaan.");

    fillBody() async {
      List<daily_reflection> dailyReflections = await getDailyReflections(
          learninggoalSubject.getBeginingDate,
          learninggoalSubject.getEndingDate);
      print("test: " + dailyReflections[0].toString());
      setState(() {
        generatedBody = dailyReflections;
      });
    }

    if (!justOnce) {
      justOnce = true;
      fillBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dagreflecties van' + learninggoalSubject.getSubject),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: generatedBody.length,
                itemBuilder: (context, index) {
                  return _buildRow(generatedBody[index]);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(daily_reflection reflection) {
    return Row(
      children: [
        Container(
            width: 300,
            decoration: Style().borderStyling(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                reflection.getDateType.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Rating: ${reflection.getRating}',
                      textAlign: TextAlign.left),
                  Text(
                    'Tag: ' + reflection.getTagsByIndex(0),
                    textAlign: TextAlign.right,
                  ),
                  Text('Subtag: ${reflection.getSubTagsByIndex(1)}'),
                  Text('Opmerking: ${reflection.getComment}')
                ],
              )
            ]))
      ],
    );
  }

  Future<List<daily_reflection>> getDailyReflections(
      DateTime start, DateTime end) async {
    final prefs = await SharedPreferences.getInstance();
    List<dynamic> reflections = await reflectionController.getList;
    List<daily_reflection> result = [];

    for (var entry in reflections) {
      print("entry: " + json.decode(entry).toString());
      daily_reflection decodedEntry =
          daily_reflection.fromJson(json.decode(entry));
      if (start.difference(decodedEntry.getDateType).inHours <= 0 &&
          end.difference(decodedEntry.getDateType).inHours >= 0) {
        result.add(decodedEntry);
      }
    }
    print("result: " + result.toString());
    return result;
  }
}
