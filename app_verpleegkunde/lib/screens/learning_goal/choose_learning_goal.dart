
import 'package:flutter/material.dart';
import 'package:flutter_application_1/functions/list_controller.dart';
// ignore: import_of_legacy_library_into_null_safe

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
  
  list_controller leerdoelenController = list_controller('leerdoelen');
  list_controller favorietenController = list_controller('favorieten');


  //  Future<List<String>?> leerdoelen = leerdoelen.getList();
  
  bool justOnce = false;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Future<void> update() async{
    print('Updated!');
    List savedLeerdoelen = await leerdoelenController.getList;
    List savedFavorieten = await favorietenController.getList;

    setState(() {
      leerdoelen = savedLeerdoelen;
      favorieten = savedFavorieten;
    });
    
  }

  // Future<List<String>?> _getPreferences(String type) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   List<String>? list = prefs.getStringList(type);
  //   if(type == 'Leerdoelen'){list ??= ['Assertief Benaderen','Conflicthantering','Vragen om hulp','Interproffesionele communicatie','Doen alsof je druk bezig bent',]; }
  //   if(type == 'Favorieten'){list ??= [];}

  //   return list;
  // }
  // Future<void> _setNewList(String type, List<String> list) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList(type, list);
  //   _updateLeerdoelen();
  //   _updateFavorieten();
  // }

  // void _updateLeerdoelen() async {
  //   List<String>? list = await _getPreferences('Leerdoelen');

  //   if (mounted) {
  //     setState(() {
  //       leerdoelen = list as List;
  //     });
  //   }
  // }

  // Future<void> _addLeerdoel(String value) async {
  //   List<String>? list = await _getPreferences('Leerdoelen');
  //   list!.add(value);
  //   _setNewList('Leerdoelen', list);
  // }

  // Future<void> _removeLeerdoel(String value) async {
  //   List<String>? list = await _getPreferences('Leerdoelen');
  //   list!.remove(value);
  //   _setNewList('Leerdoelen', list);
  // }

  // void _updateFavorieten() async {
  //   List<String>? list = await _getPreferences('Favorieten');
  //     setState(() {
  //       favorieten = list as List;
  //     });
  //   }
  
  // Future<void> _addFavorieteLeerdoel(String value) async {
  //   List<String>? list = await _getPreferences('Favorieten');
  //   list!.add(value);
  //   _setNewList('Favorieten', list);
  // }

  // Future<void> _removeFavorieteLeerdoel(String value) async {
  //   List<String>? list = await _getPreferences('Favorieten');
  //   list?.remove(value);
  //   _setNewList('Favorieten', list!);
  // }

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    if(!justOnce){
      justOnce = true;
      update();
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
                                leerdoelenController.add(myController.text);
                                update();
                                justOnce = false;
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
            update();
            justOnce = false;
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
                    favorietenController.remove(leerdoel);
                    update();
                    justOnce = false;
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
            update();
            justOnce = false;
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
                              leerdoelenController.remove(value);
                              favorietenController.remove(value);

                              //update niet goed
                              update();
                              justOnce = false;
                           
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
                      favorietenController.remove(value);
                      update();
                      justOnce = false;
                    } else {
                      favorietenController.add(value);
                      update();
                      justOnce = false;
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
