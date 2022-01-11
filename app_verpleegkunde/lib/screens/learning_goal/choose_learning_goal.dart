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

  List leerdoelen = [];
  List favorieten = [];
  
  bool justOnce = false;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Future<List<String>?> _getPreferences(String type) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? list = prefs.getStringList(type);
    if(type == 'Leerdoelen'){list ??= ['Assertief Benaderen','Conflicthantering','Vragen om hulp','Interproffesionele communicatie','Doen alsof je druk bezig bent',]; }
    if(type == 'Favorieten'){list ??= [];}

    return list;
  }
  Future<void> _setNewList(String type, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(type, list);
    _updateLeerdoelen();
    _updateFavorieten();
  }

  void _updateLeerdoelen() async {
    List<String>? list = await _getPreferences('Leerdoelen');

    if (mounted) {
      setState(() {
        leerdoelen = list as List;
      });
    }
  }

  Future<void> _addLeerdoel(String value) async {
    List<String>? list = await _getPreferences('Leerdoelen');
    list!.add(value);
    _setNewList('Leerdoelen', list);
  }

  Future<void> _removeLeerdoel(String value) async {
    List<String>? list = await _getPreferences('Leerdoelen');
    list!.remove(value);
    _setNewList('Leerdoelen', list);
  }

  void _updateFavorieten() async {
    List<String>? list = await _getPreferences('Favorieten');
      setState(() {
        favorieten = list as List;
      });
    }
  
  Future<void> _addFavorieteLeerdoel(String value) async {
    List<String>? list = await _getPreferences('Favorieten');
    list!.add(value);
    _setNewList('Favorieten', list);
  }

  Future<void> _removeFavorieteLeerdoel(String value) async {
    List<String>? list = await _getPreferences('Favorieten');
    list?.remove(value);
    _setNewList('Favorieten', list!);
  }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    if(!justOnce){
      justOnce = true;
      _updateLeerdoelen();
      _updateFavorieten();
    }
   
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leerdoelen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _favorietenLijst,
              tooltip: 'Favoriete leerdoelen',
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
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
                builder: (BuildContext context) => AlertDialog(
                        title: const Text('Nieuw Leerdoel:'),
                        content: TextField(
                          controller: myController,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Annuleer',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (myController.text.isNotEmpty) {
                                _addLeerdoel(myController.text);
                              } else {
                                ScaffoldMessenger.of(this.context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text('Veld is leeg')));
                              }
                            },
                            child: const Text(
                              'Voeg toe',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ]));
          },
          child: const Icon(Icons.add),
        ));
  }

  void _favorietenLijst() async {
    
    final result = await Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (context) {
          if(!justOnce){
            justOnce = true;
            _updateFavorieten();
          }
          final tiles = favorieten.map(
            (leerdoel) {
              return Card(
                child: ListTile(
                  title: Text(
                    leerdoel,
                    style: _biggerFont,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                onPressed: () {
                  setState(() {
                    _removeFavorieteLeerdoel(leerdoel);
                    Navigator.pop(context);  // pop current page
                    ScaffoldMessenger.of(this.context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(SnackBar(
                                      content: Text('$leerdoel uit favorieten gehaald')));
                    
                  });
                },
                icon: const Icon(
                  Icons.favorite,
                  color:  Colors.red,
                )),
                    ],), onTap: () {
          Navigator.pop(context, leerdoel);
          },
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
    setState(() {
      if ('$result' != 'null') { Navigator.pop(context, result); 
      }
    });
  }

  Widget _buildRow(String value) {
        if(!justOnce){
            justOnce = true;
            _updateFavorieten();
          }
    final alreadySaved = favorieten.contains(value);
    bool isPressed = false;
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
                      isPressed = true;
                    showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: const Text('Wil je dit leerdoel verwijderen?'),
                        content: Text(value),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Annuleer',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _removeLeerdoel(value);
                              _removeFavorieteLeerdoel(value);
                                ScaffoldMessenger.of(this.context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text('Leerdoel is verwijderd')));

                            },
                            child: const Text(
                              'Verwijder leerdoel',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ]));
                  },
                  );},
                icon: Icon(
                  isPressed ? Icons.delete : Icons.delete_outline,
                  color: isPressed ? Colors.green : null,
                  semanticLabel: isPressed ? 'Remove' : 'Keep',
                )),
                //end of Delete
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
