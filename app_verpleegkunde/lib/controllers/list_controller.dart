import 'package:shared_preferences/shared_preferences.dart';

class list_controller {
  String type;

  //Constructor
  list_controller(this.type);

  Future<List> get getList async {
    //Get the shared preferences
    final prefs = await SharedPreferences.getInstance();

    //Get the requested list
    List<String>? list = prefs.getStringList(type);

    //If empty, fill per type
    if (type == 'leerdoelen') {
      list ??= [
        'Actieplan',
        'Voorbeeld',
        'Moeizaam',
        'Lastige situatie',
        'Vooruitgang',
        'Bespreken met mentor',
        'Bespreken op Hanzedag'
      ];
    }
    if (type == 'favorieten') {
      list ??= [];
    }
    if (type == 'tag') {
      list ??= [
        //Negative Emotions
        'Boos',
        'Bang',
        'Onzeker',
        'Moe',
        'Verdrietig',
        'Eenzaam',
        'Onbekwaam',
        'Gefrustreerd',
        'Verlegen',
        // Positive Emotions
        'Blij',
        'Opgelucht',
        'Enthousiast',
        'Gemotiveerd',
        'Gesteund',
        'Energiek',
        'Bekwaam',
        'Moedig',
        'Nieuwsgierig',
        'Tevreden',
      ];
    }

    //voor overige
    else {
      list ??= [];
    }

    //return said list
    return list;
  }

  Future<void> setList(List newList) async {
    //Get the shared preferences
    final prefs = await SharedPreferences.getInstance();

    //Set the new List for given type
    prefs.setStringList(type, newList as List<String>);
  }

  Future<void> add(String value) async {
    List list = await getList;
    list.add(value);
    setList(list);
  }

  Future<void> remove(String value) async {
    List list = await getList;
    list.remove(value);
    setList(list);
  }
}
