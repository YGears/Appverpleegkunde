import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Logging/log_controller.dart';
import 'list_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
// import "list_controller.dart";

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Syncronisation {

  static Future<bool> login(String user_name, String password) async{
    final prefs = await SharedPreferences.getInstance();      
    prefs.setString('user', user_name);
    prefs.setString('password', password);
    return true;
  }

  static Future<bool> send_log_data()async{
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();
  
    log_controller log_control = log_controller();

    var data = await log_control.get();
    // print(data);
    // var json_data = "[";
    // for(var log in data){
    //   json_data += log + ",";
    // }
    // json_data += "]";
    // print("0");
    // print(json_data);

    // return true;
    var name =  prefs.getString('user');
    var password = prefs.getString('password');
    return api.logUp(name, password, data.toString());
  }
  
  static Future<bool> syncUp() async{
    final prefs = await SharedPreferences.getInstance();
    var syncCheck = prefs.getString("syncCheck") ;
    print("time: ");
    // print(syncCheck.toString());
    // print(DateTime.parse(syncCheck.toString()));
    
    Api api = new Api();
    var time = DateTime.now();
    var today = DateFormat('yyyy-MM-dd kk:mm:ss').format(time).toString();

    var name = prefs.getString('user');
    var password = prefs.getString('password');
    var reflectie_json = await list_controller("daily_reflection").getList;
    var leerdoel_json = await list_controller("leerdoel").getList;
    var week_reflectie_json = await list_controller("week_reflectie").getList;
    
    var data = "{";
    data += "\"reflectie\":" + reflectie_json.toString() + ",";
    data += "\"leerdoel\":" + leerdoel_json.toString() + ",";
    data += "\"weekreflectie\":" + week_reflectie_json.toString() + ",";
    data += "}";
    
    if(await api.syncUp(name, password, data)){
      if(await send_log_data()){
          prefs.setString("syncCheck", "{\"timestamp\":\"$today\"}");
          prefs.setStringList("log",  ["{\"timestamp\": \"" + time.year.toString() + "-" +  time.month.toString() + "-" +  time.day.toString() + "T" +  time.hour.toString() + ":" +  time.minute.toString() + ":" +  time.second.toString() + "\", \"action\": \"syncronised with DB\"}"]);
          print(list_controller("log").getList);
          return true;
        }
      }
    return false;
  }
}
