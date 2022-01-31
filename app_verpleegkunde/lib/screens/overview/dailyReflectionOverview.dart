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
      List<dynamic> dailyReflections = await getDailyReflections(
          learninggoalSubject.getBeginingDate,
          learninggoalSubject.getEndingDate);

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
    //cleanup reflection values
    // if (reflection.getComment == "") {
    //   reflection.opmerking = "geen opmerking geplaats";
    // }
    // if (reflection.tags == "") {
    //   reflection.tags = ["geen tag gekozen"];
    // }
    // if (reflection.all_sub_tags.toString() == "") {
    //   reflection.all_sub_tags = ["geen subtags gekozen"];
    // }

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
                    'Tag: ' + reflection.getTagList.toString(),
                    textAlign: TextAlign.right,
                  ),
                  Text('Subtag: ${reflection.getSubTagList.toString()}'),
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
    // print(prefs.getStringList('daily_reflection'));
    List<daily_reflection> result = [];

    for (var entry in reflections) {
      print(json.decode(entry));
      daily_reflection decodedEntry =
          daily_reflection.fromJson(json.decode(entry));
      print(decodedEntry.toString());
      // print("start: " +
      //     start.toString() +
      //     " | end: " +
      //     end.toString() +
      //     " | daily: " +
      //     decodedEntry.getDateType.toString());
      // print(decodedEntry);
      if (start.difference(decodedEntry.getDateType).inHours <= 0 &&
          end.difference(decodedEntry.getDateType).inHours >= 0) {
        result.add(decodedEntry);
      }
    }

    // print(result);
    return result;
  }

  // DateTime formatDateTimes(String datum) {
  //   List<String> gesplitst = datum.split('/');
  //   if (gesplitst[1].length < 2) {
  //     gesplitst[1] = '0' + gesplitst[1];
  //   }
  //   if (gesplitst[0].length < 2) {
  //     gesplitst[0] = '0' + gesplitst[0];
  //   }

  //   String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
  //   DateTime result = DateTime.parse(reassemble);
  //   return result;
  // }
}
