import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Logging/log_controller.dart';
import 'package:flutter_application_1/database_connection/list_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dailyReflectionOverview extends StatefulWidget {

  List<String> learningGoal = [];

  dailyReflectionOverview(List<String> learninggoal, {Key? key}) : super(key: key){
    learningGoal = learninggoal;
  }

  // List<Widget> getLearninggoal(){
  //   return learningGoal;
  // }

  @override
  dailyReflectionOverviewState createState() => dailyReflectionOverviewState(learningGoal);


}


class dailyReflectionOverviewState extends State<dailyReflectionOverview> {

  log_controller log = log_controller();
  list_controller reflectionController = list_controller('daily_reflection');
  bool justOnce = false;
  List<dynamic> generatedBody = [];


  String learninggoalSubject = '';
  String learninggoalStartDate = '';
  String learninggoalEndDate = '';
  dailyReflectionOverviewState(learninggoal){
    learninggoalSubject = learninggoal[0];
    learninggoalStartDate = learninggoal[1];
    learninggoalEndDate = learninggoal[2];
  }

  @override
  Widget build(BuildContext context) {
    log.record("Is naar de kies leerdoel pagina gegaan.");
    final myController = TextEditingController();

    fillBody() async{
      List<dynamic> dailyReflections = await getDailyReflections(formatDateTimes(learninggoalStartDate), formatDateTimes(learninggoalEndDate));
      List<dynamic> listToReturn = [];

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
          title: Text('Dagreflecties van$learninggoalSubject'),
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
  Widget _buildRow(String value) {

      return Text(value);
  }

  Future<List<dynamic>> getDailyReflections(DateTime start, DateTime end) async {
  List<dynamic> reflections = await reflectionController.getList;
  List<String> result = [];

  for (var entry in reflections) {
    if (entry != null) {
      var decodedEntry = json.decode(entry);
      if (start.difference(DateTime.parse(decodedEntry["datum"])).inHours <
               0 &&
          end.difference(DateTime.parse(decodedEntry["datum"])).inHours >
              0) {
        result.add(entry);

        //TESTING
        daily_reflection dailyReflection = daily_reflection.fromJson(jsonDecode(entry));

        print(dailyReflection);
        print(dailyReflection.rating);

        
      }
    }
  }
  print(result.runtimeType);
  return result;
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
}