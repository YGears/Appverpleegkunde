// ignore_for_file: camel_case_types


import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dailyReflectionPage extends StatefulWidget {
  dailyReflectionPage({Key? key, required this.selectedDate}) : super(key: key);
  final DateTime selectedDate ;
  @override
  State<dailyReflectionPage> createState() => _dailyReflectionPageState(selectedDate);
}

class _dailyReflectionPageState extends State<dailyReflectionPage> {
  var selectedDate = DateTime.now();
  var selected_day = "";
  String activatedMainTag = "";
  List selectedTags = [];
  List<Row> generatedBody = [];
  List<Row> generatedTagBody = [];
  List<Row> generatedSubTagBody = [];
  Map subtags = HashMap<String, List<String>>();
  List<List<Row>> bodies = [];
  int activatedPage = 1;
  final dagRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  _dailyReflectionPageState(this.selectedDate){
    selected_day = selectedDate.year.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.day.toString(); 
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
        selected_day = selectedDate.year.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.day.toString(); 
      });
    }
  }

  List getTags(){
    List list = ["Leerdoel1", "stage", "tag1", "tag2", "leuk"];
    return list;
  }

  gotoTagBody(){
    setState(() {
      activatedPage = 0;
    });
  }

  gotoSubTag(tag){
    setState(() {
      activatedMainTag = tag;
      activatedPage = 2;
    });
    
  }

  gotoDailyReflection(){
    setState(() {
      activatedPage = 1;
    });
  }

  addSubTag(String tag){
    if(!subtags.containsKey(activatedMainTag)){
      setState(() {
        subtags[activatedMainTag] =  [tag];
      });
    }
    
    List<String> tempList = subtags[activatedMainTag];
    if(subtags[activatedMainTag][0] == ""){
      tempList = [];
    }

    if(!tempList.contains(tag)){
      setState(() {
        tempList.add(tag);
        subtags[activatedMainTag] =  tempList;
      });
    }
    
    generateSubTagBody();
  }

  addMainTag(tag){
    setState(() {
      if(!selectedTags.contains(tag)){
        selectedTags.add(tag);
        activatedMainTag = tag;
        subtags[activatedMainTag] = [""];
      }
    });
    gotoDailyReflection();
  }

  generateSubTagBody(){
    List tags = getTags();
    List<Row> subTagBody = [Row(children:[TextButton(onPressed: ()=> {gotoDailyReflection()}, child: Text("Go Back"))])];
    for (String tag in tags){
      subTagBody.add(
        Row(
          children: [
            TextButton(
              child:Text(tag),
              onPressed: ()=> {addSubTag(tag)},
            )
          ]
        )
      );
    }
    if(subtags[activatedMainTag] != null){
      if(subtags[activatedMainTag][0].toString() != ""){
        for(String subTag in subtags[activatedMainTag]){
          subTagBody.add(
            Row(
              children: [
                Text(subTag),
              ]
            )
          );
        }
      }
    }
    generatedSubTagBody = subTagBody;
  }
  generateTagBody(){
    List tags = getTags();
    List<Row> tagBody = [];
    for (String tag in tags){
      tagBody.add(
        Row(
          children: [
            TextButton(
              child:Text(tag),
              onPressed: ()=> {addMainTag(tag)},
            )
          ]
        )
      );
    }
    generatedTagBody = tagBody;
  }

  String convertToJSON(){
    var rating = dagRatingController.value.text;
    var freeWrite = freeWriteController.value.text;
    bool tagged = false;
    String json = "{";

    json += "\"datum\": \"$selectedDate\",";
    if(rating != ""){
      json += "\"rating\": $rating,";
    }else{
      json += "\"rating\": 0,";
    }
    json += "\"opmerking\": \"$freeWrite\",";
    json += "\"tag\": [";
    for(String tag in selectedTags){
      tagged = true;
      json += "\"$tag\",";
    }
    if(tagged){
      json = json.substring(0,json.length-1);
    }
    
    json += "],";
    json += "\"sub_tags\": [";

    for(String mainTag in selectedTags){
      tagged = false;
      json += "[";
      for(String subTag in subtags[mainTag]){
        if(subTag != ""){
          json += "\"$subTag\",";
          tagged = true;
        }
      }
      if(tagged){
        json = json.substring(0,json.length-1);
      }
      json += "]";
    }
    json += "]";
    json += "}";
    print(json);
    return json;
  }

  Future<void> saveDailyReflection() async{
    print("printing.....");
    final prefs = await SharedPreferences.getInstance();
    List<String>? daily_reflections = prefs.getStringList('daily_reflection');
    daily_reflections ??= [];
    daily_reflections.add(convertToJSON());
    
    prefs.setStringList('daily_reflection', daily_reflections);
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
          Text("Reflectie op dag: "),
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
      Row(children:[ Text("Freewrite") ], ),
      Row(children:[Flexible(child:
        TextField(maxLines: 8, controller: freeWriteController ),
      )],),
      Row(children:[
        TextButton(
          child: Text("Select tag"),
          onPressed: ()=> {gotoTagBody()},
        ),
      ],),
    ];
    
    tempBody.addAll(addTags());

    tempBody.add(
      Row(
        children: [
          ElevatedButton(child: Text("Save Reflection"), onPressed: ()=> {saveDailyReflection()} )
        ],
      ),
    );

    setState(() {
      generatedBody = tempBody;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    
    generateTagBody();
    generateBody();
    generateSubTagBody();
    bodies.clear();
    bodies.add(generatedTagBody);
    bodies.add(generatedBody);
    bodies.add(generatedSubTagBody);
    return Scaffold(
        body: Builder(
          builder: (context) => Scaffold(
            //Topheader within the application
            appBar: AppBar(
              title: const Text('Hanze Verpleegkunde'),
              centerTitle: true,
            ),
            // Body of the application
            body: Column(
              children: bodies[activatedPage]
            )
          ),
        ));
  }
}