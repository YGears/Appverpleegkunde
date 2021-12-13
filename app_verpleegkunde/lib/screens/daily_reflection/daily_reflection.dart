// ignore_for_file: camel_case_types


import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    for(List<String> tag in subtags.values){
      for(String subTag in tag){
        subTagBody.add(
          Row(
            children: [
              Text(subTag),
            ]
          )
        );
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

  generateBody(){
    List<Row> tempBody = [
      Row(
        children: [
          Text("Reflectie op dag: "),
          ElevatedButton(child: Text(selected_day), onPressed: ()=> {_selectDate(context)} )
        ],
      ),
      Row(
        children:  [
          Text("Rating van dag: "),
          Flexible(child: 
            TextField(decoration: InputDecoration(
              labelText: ""),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              controller: dagRatingController
            ),
          ),
        ],
      ),
      Row(
        children:[
          TextButton(
            child: Text("Select tag"),
            onPressed: ()=> {gotoTagBody()},),
        ],
      ),
    ];
    
    for (var item in selectedTags){
      tempBody.add(
        Row(
          children:[
            TextButton(child:Text(item),onPressed: ()=>{gotoSubTag(item)},)
          ]
        )
      );
    }
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
