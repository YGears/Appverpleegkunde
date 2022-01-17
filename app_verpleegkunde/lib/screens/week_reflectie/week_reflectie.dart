// ignore_for_file: camel_case_types

import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class week_reflectie extends StatefulWidget {
  week_reflectie({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate;
  @override
  State<week_reflectie> createState() =>
      week_reflectie_State(selectedDate);
}

class week_reflectie_State extends State<week_reflectie> {
  var selectedDate = DateTime.now();
  var selected_day = "";
  String activatedMainTag = "Click Here";
  List selectedTags = [];
  List<Row> generatedBody = [];
  List<Row> generatedTagBody = [];
  List<Row> generatedSubTagBody = [];
  Map subtags = HashMap<String, List<String>>();
  List<List<Row>> bodies = [];
  int activatedPage = 1;
  final dagRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  week_reflectie_State(this.selectedDate) {
    selected_day = selectedDate.year.toString() +
        "/" +
        selectedDate.month.toString() +
        "/" +
        selectedDate.day.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    dagRatingController.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        selected_day = selectedDate.year.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.day.toString();
      });
    }
  }

  Future<List<String>> getTags() async{
    final prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('leerdoel') ?? [];
    return list;
  }

  gotoTagBody() {
    setState(() {
      activatedPage = 0;
    });
  }

  gotoSubTag(tag) {
    setState(() {
      activatedMainTag = tag;
      activatedPage = 2;
    });
  }

  gotoDailyReflection() {
    setState(() {
      activatedPage = 1;
    });
  }

  addMainTag(tag) {
    setState(() {
      activatedMainTag = tag;
    });
    gotoDailyReflection();
  }


  generateTagBody() async{
    List<String> tags = await getTags();
    // var jtag = json.decode(tags[0])["onderwerp"];
    // print(jtag);
    List<Row> tagBody = [];
    for (String tag in tags) {
      tagBody.add(Row(children: [
        TextButton(
          child: Text(json.decode(tag)["onderwerp"]),
          onPressed: () => {addMainTag(json.decode(tag)["onderwerp"])},
        )
      ]));
    }
    generatedTagBody = tagBody;
  }

  String convertToJSON() {
    var rating = dagRatingController.value.text;
    var freeWrite = freeWriteController.value.text;
    bool tagged = false;
    var datum_format = DateFormat('dd/MM/yyyy');
    var datum = datum_format.format(selectedDate);
    var weekNR = 5;
    String json = "{";

    json += "\"datum\": \"$datum\",";
    json += "\"weeknummer\": $weekNR,";
    if(rating != ""){
      json += "\"rating\": $rating,";
    }else{
      json += "\"rating\": 0,";
    }
    json += "\"leerdoel\": \"$activatedMainTag\",";
    json += "\"vooruitblik\": \"$freeWrite\",";
    json += "}";
    print(json);
    return json;
  }

  Future<void> saveDailyReflection() async {
    print("printing.....");
    final prefs = await SharedPreferences.getInstance();
    List<String>? daily_reflections = prefs.getStringList('week_reflectie');
    daily_reflections ??= [];
    daily_reflections.add(convertToJSON());

    prefs.setStringList('week_reflectie', daily_reflections);
    print("Done");
  }

  addTags(){
    List<Row> tags_to_return = [];
    for (var item in selectedTags){
      tags_to_return.add(
        Row(
          children:[
            TextButton(child:Text(item),onPressed: ()=>{gotoSubTag(item)},)
          ]
        )
      );
    }
    return tags_to_return;
  }

  generateBody(){
    List<Row> tempBody = [
      Row(children: [
          Text("Reflectie op week (Maandag - Zondag): "),
          ElevatedButton(child: Text(selected_day), onPressed: ()=> {_selectDate(context)} )
        ],),
      Row(
        children:  [
          Text("Rating van dag: "),
          Flexible(child: 
            TextField(
              decoration: InputDecoration(labelText: ""), 
              keyboardType: TextInputType.number, 
              inputFormatters: <TextInputFormatter>[ FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1) ], 
              controller: dagRatingController
            ),
          ),
        ],
      ),
      Row(children:[ Text("Vooruitblik:") ], ),
      Row(children:[Flexible(child:
        TextField(maxLines: 8, controller: freeWriteController ),
      )],),
      Row(children:[Text("Select tag"),
        TextButton(
          child: Text(activatedMainTag),
          onPressed: ()=> {gotoTagBody()},
        ),
      ],),
    ];
    
    tempBody.addAll(addTags());

    tempBody.add(
      Row(
        children: [
          ElevatedButton(
              child: Text("Save Reflection"),
              onPressed: () => {saveDailyReflection()})
        ],
      ),
    );

    setState(() {
      generatedBody = tempBody;
    });
  }

  @override
  Widget build(BuildContext context){
    generateTagBody();
    generateBody();
    bodies.clear();
    bodies.add(generatedTagBody);
    bodies.add(generatedBody);
    bodies.add(generatedSubTagBody);
    return Scaffold(
      //Topheader within the application
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      // Body of the application
      body: Column(children: bodies[activatedPage]),
    );
  }
}
