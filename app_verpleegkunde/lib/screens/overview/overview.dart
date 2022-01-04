import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override

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

  @override
  // Widget that builds the scaffold that holds all the widgets that this screen consists off
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overzicht van Leerdoelen"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      // Body of the application
      body: null,
    );
  }
}
