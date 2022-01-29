import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Logging/log_controller.dart';
import 'package:flutter_application_1/database_connection/list_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style.dart';

class dailyReflectionOverview extends StatefulWidget {

  List<String> learningGoal = [];

  dailyReflectionOverview(List<String> learninggoal, {Key? key}) : super(key: key){
    learningGoal = learninggoal;
  }

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

    fillBody() async{
      List<dynamic> dailyReflections = await getDailyReflections(formatDateTimes(learninggoalStartDate), formatDateTimes(learninggoalEndDate));

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
  Widget _buildRow(daily_reflection reflection) {

    //cleanup reflection values
    if(reflection.comment == ""){
      reflection.comment = "geen opmerking geplaats";
    }
    if(reflection.tag.isEmpty){
      reflection.tag = ["geen tag gekozen"];
    }
     if(reflection.subtag.isEmpty){
      reflection.subtag = ["geen subtags gekozen"];
    }

    return Row(children: [ 
      Container(
        width: 300,
        decoration: Style().borderStyling(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            reflection.date.substring(0, 16),
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
              Text('Rating: ${reflection.rating}', textAlign: TextAlign.left),
              Text('Tag: ${reflection.tag}', textAlign: TextAlign.right,),
              Text('Subtag: ${reflection.subtag}'),
              Text('Opmerking: ${reflection.comment}')

            ],
          )
          
        ])

    )],);
  }

  Future<List<dynamic>> getDailyReflections(DateTime start, DateTime end) async {
  List<dynamic> reflections = await reflectionController.getList;
  List<daily_reflection> result = [];

  for (var entry in reflections) {
    if (entry != null) {
      var decodedEntry = json.decode(entry);
      if (start.difference(DateTime.parse(decodedEntry["datum"])).inHours <
               0 &&
          end.difference(DateTime.parse(decodedEntry["datum"])).inHours >
              0) {
      
        daily_reflection dailyReflection = daily_reflection.fromJson(jsonDecode(entry));        
        result.add(dailyReflection);
      }
    }
  }

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