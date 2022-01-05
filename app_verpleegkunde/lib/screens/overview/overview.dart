import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class learningGoalOverview extends StatefulWidget {
  // Iets voor de routes maar wat?
  const learningGoalOverview({Key? key}) : super(key: key);

  @override
  learningGoalOverviewState createState() => learningGoalOverviewState();
}

// ignore: camel_case_types
class learningGoalOverviewState extends State<learningGoalOverview> {
  List<Widget> generatedBody = [];
  bool justOnce = false;

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
        print(decodedLearningGoals);
        listToReturn.add(Row(
          children: [
            selectPeriod(
                context,
                decodedLearningGoals["begin_datum"],
                decodedLearningGoals["eind_datum"],
                decodedLearningGoals["onderwerp"])
          ],
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
        title: Text("Overzicht van leerdoelen"),
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
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: generatedBody.length,
                itemBuilder: (context, index) {
                  return generatedBody[index];
                }),
          ],
        ),
      ),
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
  Widget selectPeriod(
      BuildContext context, String startDate, String endDate, String testie) {
    return Container(
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        width: 300,
        padding: const EdgeInsets.all(10.0),
        decoration: borderStyling(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            testie,
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Column(
              children: <Widget>[
                Text(startDate),
                const SizedBox(
                  width: 20,
                ),
                Text(endDate),
              ],
            )
          ])
        ]));
  }
}
