class WeekReflection {
  String datum;
  int weeknummer;
  double rating;
  String leerdoel;
  String vooruitblik;

  WeekReflection(this.datum, this.weeknummer, this.rating, this.leerdoel, this.vooruitblik);

  factory WeekReflection.fromJson(Map<String, dynamic> parsedJson) {
    return WeekReflection(
        parsedJson['datum'],
        parsedJson['weeknummer'],
        parsedJson['rating'].toDouble(),
        parsedJson['leerdoel'],
        parsedJson['vooruitblik']);
  }

  @override
  String toString() {
    return '{"datum": "$datum", "rating": $weeknummer, "rating": ${rating.toInt()}, "leerdoel": "$leerdoel", "vooruitblik": "$vooruitblik"}';
  }

  DateTime get getDate {
  
    List<String> gesplitsteDatum = datum.split('/');
    if (gesplitsteDatum[1].length < 2) {
      gesplitsteDatum[1] = '0' + gesplitsteDatum[1];
    }

    if (gesplitsteDatum[0].length < 2) {
      gesplitsteDatum[0] = '0' + gesplitsteDatum[0];
    }

    String reassemble = gesplitsteDatum[2] + gesplitsteDatum[1] + gesplitsteDatum[0];
    DateTime result = DateTime.parse(reassemble);
    return result;
  }

  int get getWeekNumber {
    return weeknummer;
  }

  double get getsubject {
    return rating;
  }

  String get getLearningGoal {
    return leerdoel;
  }

  String get getPreview {
    return vooruitblik;
  }
}