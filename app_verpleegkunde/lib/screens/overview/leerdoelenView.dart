import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/functions/list_controller.dart';
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
         double gemiddelde = await get_average_score(formatDateTimes(decodedLearningGoals["begin_datum"]), formatDateTimes(decodedLearningGoals["eind_datum"]));
        
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
        listToReturn.add(const SizedBox(height: 10, width: 10,));
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
      body: 
      SingleChildScrollView(
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
  Widget itembox(
      BuildContext context, String startDate, String endDate, String onderwerp, String streefcijfer, double gemiddelde) {
    return 
    Container(
        // margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        width: 300,
        // padding: const EdgeInsets.all(10.0),
        decoration: borderStyling(),
        child:
         Column(
           children: [
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
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$startDate - $endDate' ),
                const SizedBox(width: 20, height: 10,),
              
                 
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
                              Navigator.of(context).pop();
                            },
      
                            child: const Text(
                              'Dagreflecties',
                              textAlign: TextAlign.left,
                            ),
                          ),
                TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Weekreflecties',
                              textAlign: TextAlign.right,
                            ),
                          ),
          ]
          )
          ]
          )
        ]));
  }
  Future<double> get_average_score(DateTime start, DateTime end)async{

    List<dynamic> reflections = await reflectionController.getList;
    var gem_cijfer = 0;
    var amount_of_reflections = 0;

    for(var entry in reflections){
      if (entry != null){
        var decoded_entry = json.decode(entry);
        if (
          start.difference(DateTime.parse(decoded_entry["datum"])).inHours < 0 &&
          end.difference(DateTime.parse(decoded_entry["datum"])).inHours > 0 
        ){
          gem_cijfer += decoded_entry["rating"] as int;   
          amount_of_reflections += 1;             
        }
      }
    }
    return gem_cijfer/amount_of_reflections;
  }

  DateTime formatDateTimes(String datum){

    List<String> gesplitst = datum.split('/');
    if(gesplitst[1].length <2){gesplitst[1] = '0' + gesplitst[1];}
    if(gesplitst[0].length <2){gesplitst[0] = '0' + gesplitst[0];}
   
    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
    DateTime result = DateTime.parse(reassemble);
    return result;

  }
}
