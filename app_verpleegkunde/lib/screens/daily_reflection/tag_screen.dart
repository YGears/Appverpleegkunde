import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_colors.dart';
import '../../controllers/log_controller.dart';
import '../../controllers/list_controller.dart';
// ignore: import_of_legacy_library_into_null_safe

/// Class to create the tag_screen view, making a list of all tag_screen available.
/// can favorite leerdoel and look at DailyReflections at a different navigation
/// Must run using flutter run --no-sound-null-safety because of shared_preferences

class TagScreen extends StatefulWidget {
  const TagScreen({Key? key}) : super(key: key);

  @override
  _TagScreen createState() => _TagScreen();
}

class _TagScreen extends State<TagScreen> {
  log_controller log = log_controller();

  List listOfPossibleTags = [];
  list_controller tagController = list_controller('tag');

  bool justOnce = false;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Future<void> updatePossibleTags() async {
    List savedDailyReflections = await tagController.getList;
    setState(() {
      listOfPossibleTags = savedDailyReflections;
    });
  }

  @override
  Widget build(BuildContext context) {
    log.record("Is naar de kies leerdoel pagina gegaan.");
    final myController = TextEditingController();

    if (!justOnce) {
      justOnce = true;
      updatePossibleTags();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Dag Reflectie Tags'),
          backgroundColor: themeColor,
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: listOfPossibleTags.length,
                  itemBuilder: (context, index) {
                    return _buildRow(listOfPossibleTags[index]);
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: const Text('Nieuwe Tag:'),
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
                                tagController.add(myController.text);
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) => updatePossibleTags());
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

  Widget _buildRow(String value) {
    if (!justOnce) {
      justOnce = true;
      updatePossibleTags();
    }
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
                  setState(
                    () {
                      isPressed = true;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  title: const Text(
                                      'Wil je deze tag verwijderen?'),
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
                                        tagController.remove(value);
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback(
                                                (_) => updatePossibleTags());
                                        ScaffoldMessenger.of(this.context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(const SnackBar(
                                              content: Text(
                                                  'De tag is verwijderd')));
                                      },
                                      child: const Text(
                                        'Verwijder tag',
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ]));
                    },
                  );
                },
                icon: Icon(
                  isPressed ? Icons.delete : Icons.delete_outline,
                  color: isPressed ? Colors.green : null,
                  semanticLabel: isPressed ? 'Remove' : 'Keep',
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
