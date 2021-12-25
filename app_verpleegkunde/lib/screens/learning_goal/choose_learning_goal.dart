// // ignore: avoid_web_libraries_in_flutter
// import 'dart:js';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';

/// Class to create the Leerdoelen view, making a list of all leerdoelen available.
/// can favorite leerdoel and look at leerdoelen at a different navigation
/// Must run using flutter run --no-sound-null-safety because of shared_preferences

class Leerdoelen extends StatefulWidget {
  const Leerdoelen({Key? key}) : super(key: key);

  @override
  _Leerdoelen createState() => _Leerdoelen();
}

class _Leerdoelen extends State<Leerdoelen> {
//setState(() {leerdoelen = gottenLeerdoelen!;});
  List<String> leerdoelen = [];
  void _updateLeerdoelen() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? gottenLeerdoelen = prefs.getStringList('Leerdoelen');
    gottenLeerdoelen ??= [
      'Assertief Benaderen',
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
      'Opvuller:'
    ];
    setState(() {
      leerdoelen = gottenLeerdoelen!;
    });
  }

  Future<void> _addLeerdoel(String value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? gottenLeerdoelen = prefs.getStringList('Leerdoelen');
    gottenLeerdoelen ??= [
      'Assertief Benaderen',
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
      'Opvuller:'
    ];
    gottenLeerdoelen.add(value);
    prefs.setStringList('Favorieten', gottenLeerdoelen);
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  List<String> favorieten = [];
  void _updateFavorieten() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favorieteLeerdoelen = prefs.getStringList('Favorieten');
    if (favorieteLeerdoelen != null) {
      setState(() {
        favorieten = favorieteLeerdoelen!;
      });
    } else {
      favorieteLeerdoelen = [''];
    }
  }

  Future<void> _removeFavorieteLeerdoel(String value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favorieteLeerdoelen = prefs.getStringList('Favorieten');
    favorieteLeerdoelen?.remove(value);
    prefs.setStringList('Favorieten', favorieteLeerdoelen!);
  }

  Future<void> _addFavorieteLeerdoel(String value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favorieteLeerdoelen = prefs.getStringList('Favorieten');
    favorieteLeerdoelen ??= [];
    favorieteLeerdoelen.add(value);
    prefs.setStringList('Favorieten', favorieteLeerdoelen);
  }

  void addNewLeerdoel() {}

  @override
  Widget build(BuildContext context) {
    _updateLeerdoelen();
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
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Text('Hier is ruimte om iets aan te passen', style: _biggerFont),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: leerdoelen.length,
                  itemBuilder: (context, index) {
                    return _buildRow(leerdoelen[index]);
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                      title: Text('Dialog Title'),
                      content: Text('This is my content'),
                    ));
          },
          child: const Icon(Icons.add),
        ));
  }

  void _pushSaved() {
    Navigator.of(this.context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          _updateFavorieten();
          final tiles = favorieten.map(
            (leerdoel) {
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
              : <Widget>[];

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

  Widget _buildRow(String value) {
    _updateFavorieten();
    final alreadySaved = favorieten.contains(value);
    return Card(
      child: ListTile(
        title: Text(
          value,
          style: _biggerFont,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _removeFavorieteLeerdoel(value);
                    } else {
                      _addFavorieteLeerdoel(value);
                    }
                  });
                },
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                )),
          ],
        ),
        onTap: () {
          Navigator.pop(context, value);
        },
      ),
    );
  }
}
