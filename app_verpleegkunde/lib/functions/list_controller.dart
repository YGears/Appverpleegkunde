import 'package:shared_preferences/shared_preferences.dart';

class list_controller{


  String type;
  
  //Constructor
  list_controller(this.type);


  Future<List> get getList async {
    //Get the shared preferences
    final prefs = await SharedPreferences.getInstance();

    //Get the requested list
    List<String>? list = prefs.getStringList(type);

    //If empty, fill per type
    if(type == 'leerdoelen'){list ??= ['Assertief Benaderen','Conflicthantering','Vragen om hulp','Interproffesionele communicatie','Doen alsof je druk bezig bent',]; }
    if(type == 'favorieten'){list ??= [];}
    if(type == 'tag'){list ??= [];}
    //voor overige
    else{list ??= [];}
    

    //return said list

  return list as List;
  }

  Future<void> setList(List newList) async{
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