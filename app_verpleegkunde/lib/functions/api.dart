import 'dart:async';
import 'dart:convert';
import 'log_controller.dart';
import 'package:http/http.dart' as http;

class Response {
  final String response;

  Response({
    required this.response,
  });

  getResponse() {
    return response;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      response: json['response'],
    );
  }
}

// in order to use the group api, replace privateApi with groupApi on line 30, 
// comment out line 32
class Api {
  var log = log_controller();
  Future<bool> login(id, password) async {
    print("loggin in");
    // var privateApi = "https://iabamun.nl/game/lab-andre/api/index.php/login";
    // final response = await http.post(
    //   Uri.parse(privateApi),
    //   headers:{'Ocp-Apim-Subscription-Key': 'KEY' },
    //   body: jsonEncode(<String, String>{"name": id, "password": password, }),
    // );
    // azure api
    var groupApi = "https://nurse-it-api.azure-api.net/Nurse-IT/Login?=&name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=c09877a3381f444d9cc9c3e6f2de29f7";
     
    final response = await http.get(
      Uri.parse(groupApi), 
      headers: {
      }
    );

    var data = jsonDecode(response.body); 
    
    if (data['response'] != null) {
      if (data['response'] == "Logged in") {
        log.record("Logged in");
        return true;
      }
    }
    return false;
  }

  Future<bool> syncUp(user_name, password, reflectie_json, leerdoel_json, week_reflectie_json) async{
    var groupApi = "https://nurse-it-api.azure-api.net/Nurse-IT/UpdateUser?name=$user_name&password=$password&subscription-key=c09877a3381f444d9cc9c3e6f2de29f7&reflectie=$reflectie_json&leerdoel=$leerdoel_json&weekreflectie=$week_reflectie_json";

    final response = await http.post(
      Uri.parse(groupApi)
    );
    
    // if(response.statusCode == 200){
    
    //   return true; 
    // }else{
    //   return false;
    // }
    print(groupApi);
    return true;
  }
}
