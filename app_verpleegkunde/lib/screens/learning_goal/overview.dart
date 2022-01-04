import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class learninGoalOverview extends StatefulWidget {
  // Iets voor de routes maar wat?
  const learninGoalOverview({Key? key}) : super(key: key);

  @override
  learninGoalOverviewState createState() => learninGoalOverviewState();
}

class learninGoalOverviewState extends State<learninGoalOverview> {
  List<Widget> generatedBody = [];
  bool justOnce = false;

  @override
  Widget build(BuildContext context) {

    String convertToJSON(){
      String json = "";

      json += "{ \"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\" }";

      return json;
    }
    Future<void> createDefault() async{
      print("printing.....");
      final prefs = await SharedPreferences.getInstance();
      List<String>? leerdoelen = prefs.getStringList('leerdoel');
      leerdoelen ??= [];
      leerdoelen.add(convertToJSON());
      
      prefs.setStringList('leerdoel', leerdoelen);
      print("Done");
    }

    getTags() async{
    final prefs = await SharedPreferences.getInstance();
      List<String>? leerdoelen = prefs.getStringList('leerdoel');
      return leerdoelen;
      // return "\"leerdoel\":[{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},{\"begin_datum\": \"23-01-2021\", \"eind_datum\": \"24-01-2021\", \"onderwerp\": \"leerdoel1\"},]";
    }
    fillBody() async{
      List<String>? leerdoelen = await getTags();
      List<Widget> listToReturn = [];

      if(leerdoelen == null){ return;}
      
      for(String vari in leerdoelen){
        Map<String, dynamic> decodedLearningGoals = jsonDecode(vari);
        print(decodedLearningGoals);
        listToReturn.add(
          Row(
            children: [
              Column(
                children:[
                  Text(decodedLearningGoals["onderwerp"]),
                  Row(
                    children: [
                      Text(decodedLearningGoals["begin_datum"]),
                      Text(" - "),
                      Text(decodedLearningGoals["eind_datum"])
                    ],
                  )
                ]
              )
            ],
          )
        );
      }setState(() {
        generatedBody = listToReturn;
      });
    }
    
    if(!justOnce){print("wat");
      justOnce = true;
      fillBody();
    }
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