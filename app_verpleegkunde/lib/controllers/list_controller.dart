import 'package:shared_preferences/shared_preferences.dart';

class ListController {
  String type;
  ListController(this.type);

  Future<List> get getList async {
    //Get the shared preferences
    final prefs = await SharedPreferences.getInstance();
    //Get the requested list
    List<String>? list = prefs.getStringList(type);

    if (type == 'leerdoelen') {
      list ??= [
        'Actieplan',
        'Voorbeeld',
        'Moeizaam',
        'Lastige situatie',
        'Vooruitgang',
        'Bespreken met mentor',
        'Bespreken op Hanzedag',
        'Eigen grenzen inzien',
        'Eigen grenzen aangeven',
        'Nee zeggen',
        'Collega aanspreken op gedrag',
        'Cliënt aanspreken op gedrag',
        'Om hulp vragen',
        'Gevoelens delen',
        'Mening delen',
        'Initiatief nemen',
        'Bang voor consequenties',
        'Extra dienst / Invallen',
        'Conflinctvermijding',
        'Gebrek aan veiligheid',
      ];
    }

    if (type == 'favorieten') {
      list ??= [];
    }

    if (type == 'tag') {
      list ??= [
        'Cliënt',
        'Familie van de Cliënt',
        'Collega-verpleegkundige',
        'Verzorgkundige',
        'Regieverpleegkundige',
        'Arts',
        'Werkplekbegeleider',
        'Overdracht',
        'Pauze',
        'Roddelende collega\'s',
        'Taakverdeling',
        'Dienstbespreking',
        'Cliëntbespreking',
        'Gesprek werkplekbegeleider',
        'Ander werkoverleg',
        'Medicijnen afmeten',
        'Medicijnen toedienen',
        'Catether plaatsen/verwijderen',
        'Bloeddruk meten',
        'Wondverzorging',
        'Andere verpleegkundige handeling',
      ];
    }

    if (type == 'subtag') {
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
        'Niet gehoord worden',
        'Niet serieus genomen worden',
        'Hiërarchie',
        'Buitengesloten worden',
        'Minderwaardig voelen',
        'Geïntimideerd',
        'Oneerlijk',
        'Gehoord worden',
        'Serieus genomen worden',
        'Teamgevoel',
        'Steun vinden',
        'Gelijke status',
        'Werkvloernormen',
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
