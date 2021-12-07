// ignore_for_file: camel_case_types


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
  List selectedTags = [];
  Column generatedBody = Column();
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

  wow(context){
    setState(() {
      selected_day = "changed";
    });
  }

  List getTags(){
    List list = ["Leerdoel1", "stage", "tag1", "tag2", "leuk"];
    return list;
  }
  gotoDailyReflection(tag){
    selectedTags.add(tag);
    // generateBody(context);
  }

  generateTagBody(){
    List tags = getTags();
    List<Row> generatingBody = [];
    for (String tag in tags){
      generatingBody.add(
        Row(
          children: [
            TextButton(
              child:Text(tag),
              onPressed: ()=> {gotoDailyReflection(tag)},
            )
          ]
        )
      );
    }
    setState(() {
      generatedBody = Column(children:generatingBody);
      selected_day = "ass";
    });
  }

  generateBody(context) async{
    generatedBody = Column(children: [
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
            onPressed: ()=> {generateTagBody()},),
        ],
      )
    ]);
  }


  @override
  Widget build(BuildContext context) {generateBody(context);
    return MaterialApp(
        title: 'Hanze - Verpleegkunde',
        theme: ThemeData(
          //scaffoldBackgroundColor: const Color(0xFFe3e6e8),
          primarySwatch: Colors.orange,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            //Topheader within the application
            appBar: AppBar(
              title: const Text('Hanze Verpleegkunde'),
              centerTitle: true,
            ),
            // Body of the application
            body: generatedBody
            
          ),
        ));
  }
}
