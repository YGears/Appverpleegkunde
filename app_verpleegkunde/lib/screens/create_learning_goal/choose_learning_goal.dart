// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

/// Class to create the Leerdoelen view, making a list of all leerdoelen available.
/// can favorite leerdoel and look at leerdoelen at a different navigation
/// Must run using flutter run --no-sound-null-safety because of shared_preferences
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Verpleegkunde app',
      home: Leerdoelen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Leerdoelen extends StatefulWidget {
  const Leerdoelen({ Key? key }) : super(key: key);

  @override
  _Leerdoelen createState() => _Leerdoelen();
}

class _Leerdoelen extends State<Leerdoelen>{

  String _haveStarted3Times = '';

  final _saved = <String>{};
  final _suggestions = <String>['Assertief Benaderen', 
  'Conflicthantering', 
  'vragen om hulp',
   'interproffesionele communicatie',
    'doen alsof je druk bezig bent',
    'Opvuller1',
    'Opvuller2',
    'Opvuller3',
    'Opvuller:',
    'Opvuller:',
    'Opvuller:',
    'Opvuller:',
    'Opvuller:',
    'Opvuller:',
    'Opvuller:',
    ];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState(){
    super.initState();
    _incrementStartup();
  }
   Future<int> _getIntFromSharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    final startupNumber = prefs.getInt('startupNumber');
    if(startupNumber == null){
      return 0;
    }
    return startupNumber;
    
     
  }
  Future<void> _resetCounter() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startupNumber', 0);
  }

  Future<void> _incrementStartup() async {
    final prefs = await SharedPreferences.getInstance();

    int lastStartupNumber = await _getIntFromSharedPref();
    int currentStartupNumber = ++lastStartupNumber;

    await prefs.setInt('startupNumber', currentStartupNumber);

    if (currentStartupNumber == 3){
      setState(() => _haveStarted3Times = '$currentStartupNumber Times Completed');
      await _resetCounter();
    } else{
      setState(() => _haveStarted3Times = '$currentStartupNumber Times started the app');

    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leerdoelen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Favoriete leerdoelen',
          )
        ],
        ),
        body: 
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
          Text(_haveStarted3Times, style: _biggerFont),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10.0),
            itemCount: _suggestions.length,
            itemBuilder: (context, index){
             return _buildRow(_suggestions[index]);
              }
              ),
            ],
          ),
        ),    
      );
  }
  void _pushSaved(){
    Navigator.of(this.context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (leerdoel){
              return Card(
                child: ListTile(
                  title: Text(
                    leerdoel,
                    style: _biggerFont,
                  ),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
              :<Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoriete leerdoelen'),
            ),
            body: ListView(children: divided),
              ); 
        }, 
      ),
    );
  }
  Widget _buildRow(String pair) {
  final alreadySaved = _saved.contains(pair);
  return Card(
    child: ListTile(
  
    title: Text(
      pair,
      style: _biggerFont,
    ),
    trailing: Icon (
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red: null,
      semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',

    ),
    onTap: (){
      setState(() {
        if(alreadySaved){
          _saved.remove(pair);
      } else {
          _saved.add(pair);
      }
      });
    },
  ), );
}

}




