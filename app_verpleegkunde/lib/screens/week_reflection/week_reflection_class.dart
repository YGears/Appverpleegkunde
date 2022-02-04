
class WeekReflection {
  String datum;
  int weeknummer;
  double rating;
  String leerdoel;
  String vooruitblik;
  WeekReflection(this.datum, this.weeknummer, this.rating, this.leerdoel,
      this.vooruitblik);
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
    List<String> gesplitst = datum.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
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