import 'dart:async';
import 'dart:convert';
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
  Future<bool> login(id, password) async {
    // var privateApi = "https://iabamun.nl/game/lab-andre/api/index.php/login";
    // final response = await http.post(
    //   Uri.parse(privateApi),
    //   body: jsonEncode(<String, String>{"name": id, "password": password, }),
    // );
    print("trying");
    
    var groupApi = "https://nurse-it-api.azure-api.net/Nurse-IT/Login?name=user&password=KoekjesZijnGemaaktVanDeeg";
    final response = await http.post(
      Uri.parse(groupApi),
    //   headers:{
    //   "Host": "flutterVerpleegApp",
    //   "Content-Length": "0",
    //   "Ocp-Apim-Subscription-Key": "Ocp-Apim-Subscription-Key",
    //   "Accept": "application/json",
    //   "Access-Control-Allow-Origin": "*",
    //  },
      body:{}
    );
    print(response);
    // var data = jsonDecode(response.body);
    // print(data);
    // if (data['response'] != null) {
    //   if (data['response'] == "Logged in") {
    //     return true;
    //   }
    // }
    return false;
  }

  Future<bool> syncUp(user_name, password, reflectie_json, leerdoel_json, week_reflectie_json) async{
    var testApi = "test";
    var groupApi = "https://nurse-it.azurewebsites.net/api/test_login?name=$user_name&password=$password&reflectie=$reflectie_json&leerdoel=$leerdoel_json&week_reflectie=$week_reflectie_json";

    // final response = await http.post(
    //   Uri.parse(testApi)
    // );
    
    // if(response.statusCode == 200){
    //   return true;
    // }else{
    //   return false;
    // }
    print(groupApi);
    return true;
  }
}
