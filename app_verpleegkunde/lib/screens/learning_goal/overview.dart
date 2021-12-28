import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import '../second.dart';
import 'package:flutter/material.dart';
import 'choose_learning_goal.dart';
import 'package:http/http.dart' as http;

class learninGoalOverview extends StatefulWidget {
  // Iets voor de routes maar wat?
  const learninGoalOverview({Key? key}) : super(key: key);

  @override
  learninGoalOverviewState createState() => learninGoalOverviewState();
}

class learninGoalOverviewState extends State<learninGoalOverview> {

  @override
  Widget build(BuildContext context) {
    List<Widget> generatedBody = [];

    getTags(){
      return "{\"leerdoe01\":{\"name\": \"leerdoel1\", \"beginDate\": \"23-01-2021\", \"endDate\": \"24-01-2021\"},\"leerdoel02\": {\"name\": \"leerdoel2\", \"beginDate\": \"23-01-2021\", \"endDate\": \"24-01-2021\"}}";}

    fillBody(){
      Map<String, dynamic> decodedLearningGoals = jsonDecode(getTags());
      List<Widget> listToReturn = [];
      for(String vari in decodedLearningGoals.keys){
        print(decodedLearningGoals[vari]);
        listToReturn.add(
          Row(
            children: [
              Column(
                children:[
                  Text(decodedLearningGoals[vari]["name"]),
                  Row(
                    children: [
                      Text(decodedLearningGoals[vari]["beginDate"]),
                      Text(" - "),
                      Text(decodedLearningGoals[vari]["endDate"])
                    ],
                  )
                ]
              )
            ],
          )
        );
      }

      setState(() {
        generatedBody = listToReturn;
      });
    }

    fillBody();
    return Scaffold(
      appBar: AppBar(
        title: Text("Leerdoel"),
        centerTitle: true,
      ),
      body:Column(
        children: generatedBody
      )
    );
  }
}