import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int tableWidth = 10;
  int count = 0;
  String blapi = "asf";
  var days_in_week = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right:10, top:400),
      child: Table(
        defaultColumnWidth: FlexColumnWidth(1),
        columnWidths:{ 0: FlexColumnWidth(2)},
        children: [
          TableRow(
            children: [
            ElevatedButton(
              onPressed: (){
                _week();
              },
              child: Text("Week1"),
            ),
            Text("",style: TextStyle(color:Colors.black, fontSize: 9),),
            for (var i = 1; i < 8; i++) TextButton(
              onPressed: (){
                dag();
              },
              child: Text(days_in_week[i-1],
              style: TextStyle(color:Colors.white, backgroundColor: Colors.blue, fontSize: 7)),
              style: TextButton.styleFrom(padding:EdgeInsets.all(5), backgroundColor: Colors.blue)
              
            )
          ]),
          TableRow(
            children: [for (var i = 1; i < tableWidth; i++) Text("",style: TextStyle(color:Colors.black, fontSize: 9),)]
          ),
          TableRow(
            children: [
            ElevatedButton(
              onPressed: (){
                _week();
              },
              child: Text("Week2"),
            ),
            Text("",style: TextStyle(color:Colors.black, fontSize: 9),),
            for (var i = 1; i < 8; i++) ElevatedButton(
              onPressed: (){
                dag();
              },
              child: Text(days_in_week[i-1],style: TextStyle(color:Colors.white, fontSize: 7)),
            )
          ]),
          TableRow(
            children: [for (var i = 1; i < tableWidth; i++) Text("",style: TextStyle(color:Colors.black, fontSize: 9),)]
          ),
          TableRow(
            children: [
            ElevatedButton(
              onPressed: (){
                _week();
              },
              child: Text("Week3"),
            ),
            Text("",style: TextStyle(color:Colors.black, fontSize: 9),),
            for (var i = 1; i < 8; i++) ElevatedButton(
              onPressed: (){
                dag();
              },
              child: Text(days_in_week[i-1],style: TextStyle(color:Colors.white, fontSize: 7)),
            )
          ]),
          TableRow(
            children: [for (var i = 1; i < tableWidth; i++) Text("",style: TextStyle(color:Colors.black, fontSize: 9),)]
          ),
          TableRow(
            children: [
            ElevatedButton(
              onPressed: (){
                _week();
              },
              child: Text("Week4"),
            ),
            Text("",style: TextStyle(color:Colors.black, fontSize: 9),),
            for (var i = 1; i < 8; i++) ElevatedButton(
              onPressed: (){
                dag();
              },
              child: Text(days_in_week[i-1],style: TextStyle(color:Colors.white, fontSize: 7)),
            )
          ]),
        ]
      ),
    );
  //   return Column(
  //     children: <Widget> [
  //       ElevatedButton(
  //         onPressed: (){
  //           _selectDate(context);
  //         },
  //         child: Text("Choose Date"),
  //       ),Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", style: DefaultTextStyle.of(context).style.apply(
  //           fontSizeFactor: 0.5, 
  //           decoration: TextDecoration.none,
  //           color: Colors.black,
  //           ),
  //         ),
  //     ]
  //   );
  // }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

  }
  _week() async {
    setState(() {
      count = count + 1;
      blapi = "kliks: $blapi";
    });
  }
  dag() async {
    setState(() {
      count = count + 1;
      blapi = "kliks: $blapi";
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }
}