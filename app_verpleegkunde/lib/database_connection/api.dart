import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Logging/log_controller.dart';
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

class Tag {
  List<String> sub_tags;
  List<String> tags = [];
  Tag(this.sub_tags);
  factory Tag.fromJson(Map<String, dynamic> parsedJson) {
    List<String> tags = [];
    for (String w in parsedJson['sub_string']) {
      tags.add("\"$w\"");
    }
    return Tag(parsedJson['sub_tags']);
  }
  @override
  String toString() {
    return '{"sub_tags": $sub_tags}';
  }
}

class Reflecties {
  String datum;
  int rating;
  String opmerking;
  List<dynamic> tag;
  List<Tag> all_sub_tags_raw = [];
  List<String> all_sub_tags = [];
  List<String> tags = [];
  Reflecties(
      this.datum, this.rating, this.opmerking, this.tag, this.all_sub_tags_raw);
  factory Reflecties.fromJson(Map<String, dynamic> parsedJson) {
    List<Tag> ref;
    if (parsedJson['all_sub_tags_raw'] == null) {
      ref = [Tag([])];
    } else {
      ref = parsedJson['all_sub_tags_raw'];
    }
    print(parsedJson);
    return Reflecties(parsedJson['datum'], parsedJson['rating'],
        parsedJson['opmerking'], parsedJson['tag'], ref);
  }
  @override
  String toString() {
    for (Tag i in all_sub_tags_raw) {
      all_sub_tags.add(i.toString());
    }
    for (dynamic h in tag) {
      tags.add("\"$h\"");
    }
    return '{ "datum": "$datum", "rating": $rating, "opmerking": "$opmerking", "tag": $tag, "all_sub_tags": $all_sub_tags}';
  }
}

class Leerdoel {
  String begin_datum;
  String eind_datum;
  String onderwerp;
  int streefcijfer;
  Leerdoel(
      this.begin_datum, this.eind_datum, this.onderwerp, this.streefcijfer);
  factory Leerdoel.fromJson(Map<String, dynamic> parsedJson) {
    return Leerdoel(parsedJson['begin_datum'], parsedJson['eind_datum'],
        parsedJson['onderwerp'], parsedJson['streefcijfer']);
  }
  @override
  String toString() {
    return '{ "begin_datum": "$begin_datum", "eind_datum": "$eind_datum", "onderwerp": "$onderwerp", "streefcijfer": "$streefcijfer"}';
  }
}

class Weekreflectie {
  String datum;
  int weeknummer;
  int rating;
  String leerdoel;
  String vooruitblik;
  Weekreflectie(this.datum, this.weeknummer, this.rating, this.leerdoel,
      this.vooruitblik);
  factory Weekreflectie.fromJson(Map<String, dynamic> parsedJson) {
    return Weekreflectie(
        parsedJson['datum'],
        parsedJson['weeknummer'],
        parsedJson['rating'],
        parsedJson['leerdoel'],
        parsedJson['vooruitblik']);
  }
  @override
  String toString() {
    return '{"datum": "$datum", "rating": $weeknummer, "rating": $rating, "leerdoel": "$leerdoel", "vooruitblik": "$vooruitblik"}';
  }
}

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var log = log_controller();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    // return true;
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if ((user == null || user == "") && id != "") {
      var groupApi = url +
          "Login?name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

      final response = await http.get(
        Uri.parse(groupApi),
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
    return false;
  }

  Future<bool> getOldInfo() async {
    // return true;
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    var groupApi = url +
        "GetReflecties?=&name=$user&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

    final response = await http.get(
      Uri.parse(groupApi),
    );

    var data = jsonDecode(response.body);

    if (data != null) {
      print(response.body);

      if (data['reflecties'] != null) {
        List<String> reflecties = [];
        for (Map<String, dynamic> r in data['reflecties']) {
          Reflecties re = Reflecties.fromJson(r);
          reflecties.add(re.toString());
        }
        print(reflecties.toString());
        prefs.setStringList('daily_reflection', reflecties);
      }
      if (data['leerdoel'] != null) {
        List<String> leerdoel = [];
        for (Map<String, dynamic> l in data['leerdoel']) {
          Leerdoel le = Leerdoel.fromJson(l);
          leerdoel.add(le.toString());
        }
        // print(leerdoel.toString());
        prefs.setStringList('leerdoel', leerdoel);
      }
      if (data['week_reflectie'] != null) {
        List<String> week_reflectie = [];
        for (Map<String, dynamic> w in data['week_reflectie']) {
          Weekreflectie we = Weekreflectie.fromJson(w);
          week_reflectie.add(we.toString());
        }
        // print(week_reflectie.toString());
        prefs.setStringList('week_reflectie', week_reflectie);
      }
      print("Update completed");
      print(prefs.get("daily_reflection"));
      print(prefs.get("leerdoel"));
      print(prefs.get("week_reflectie"));
      return true;
    }
    return false;
  }

  Future<bool> syncUp(user_name, password, data) async {
    var groupApi = url +
        "UpdateUser?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: data);

    var responseText = jsonDecode(response.body);

    if (responseText["response"] == "Log updated") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logUp(user_name, password, logs) async {
    var groupApi = url +
        "UpdateLogs?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: logs);
    var data = jsonDecode(response.body);

    if (data['response'] != null) {
      if (data['response'] == "Log updated") {
        log.record("Updated log");
        return true;
      }
    }
    return false;
  }
}
