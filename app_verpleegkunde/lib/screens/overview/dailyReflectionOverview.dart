// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database_connection/api.dart';
import '../learning_goal/learning_goal.dart';
import '../week_reflection/week_reflection_class.dart';
import '../../app_colors.dart';
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
  LogController log = LogController();
  ListController reflectionController = ListController('daily_reflection');
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
      List<DailyReflection> dailyReflections = await getDailyReflections(
          learninggoalSubject.getBeginingDate,
          learninggoalSubject.getEndingDate);
      // print("test: " + dailyReflections[0].toString());
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
        backgroundColor: themeColor,
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

  Widget _buildRow(DailyReflection reflection) {
    List<Widget> buildSubTagList() {
      var body = <Widget>[
        Text('Rating: ${reflection.getRating}', textAlign: TextAlign.left),
        const Text(
          " ",
          textAlign: TextAlign.right,
        ),
        Text('Opmerking: ${reflection.getComment}'),
        const Text(
          " ",
          textAlign: TextAlign.right,
        ),
      ];

      print(reflection);

      for (int tag_amount = 0;
          tag_amount < reflection.getTagList.length;
          tag_amount++) {
        body.add(Text('Tag: ${reflection.getTagsByIndex(tag_amount)}'));
        body.add(Text('Subtag: ${reflection.getSubTagsByIndex(tag_amount)}'));
        body.add(const Text(
          " ",
          textAlign: TextAlign.right,
        ));
      }

      return body;
    }

    return Row(
      children: [
        Container(
            width: 300,
            decoration: Style().defaultBoxStyling(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                reflection.getDateType.toString().substring(0, 10),
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
                children: buildSubTagList(),
              )
            ]))
      ],
    );
  }

  Future<List<DailyReflection>> getDailyReflections(
      DateTime start, DateTime end) async {
    final prefs = await SharedPreferences.getInstance();
    List<dynamic> reflections = await reflectionController.getList;
    List<DailyReflection> result = [];

    for (var entry in reflections) {
      DailyReflection decodedEntry =
          DailyReflection.fromJson(json.decode(entry));
      if (start.difference(decodedEntry.getDateType).inHours <= 0 &&
          end.difference(decodedEntry.getDateType).inHours >= 0) {
        result.add(decodedEntry);
      }
    }
    // print("result: " + result.toString());
    return result;
  }
}
