class Tag {
  List<String> sub_tags;
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

  List<String> get getSubTagList {
    return sub_tags;
  }
}

class daily_reflection {
  String datum;
  double rating;
  String opmerking;
  List<dynamic> tag;
  List<Tag> all_sub_tags_raw = [];
  List<String> all_sub_tags = [];
  List<String> tags = [];
  daily_reflection(
      this.datum, this.rating, this.opmerking, this.tag, this.all_sub_tags_raw);
  factory daily_reflection.fromJson(Map<String, dynamic> parsedJson) {
    List<Tag> ref;
    if (parsedJson['all_sub_tags_raw'] == null) {
      ref = [Tag([])];
    } else {
      ref = parsedJson['all_sub_tags_raw'];
    }
    print(parsedJson);
    return daily_reflection(
        parsedJson['datum'],
        parsedJson['rating'].toDouble(),
        parsedJson['opmerking'],
        parsedJson['tag'],
        ref);
  }
  @override
  String toString() {
    for (Tag i in all_sub_tags_raw) {
      all_sub_tags.add(i.toString());
    }
    for (dynamic h in tag) {
      tags.add("\"$h\"");
    }
    print(all_sub_tags);
    return '{ "datum": "$datum", "rating": $rating, "opmerking": "$opmerking", "tag": ${tags.toString()}, "all_sub_tags": $all_sub_tags}';
  }

  DateTime get getDate {
    return DateTime.parse(datum);
  }

  DateTime get getDateType {
    List<String> gesplitst = datum.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[2].length < 2) {
      gesplitst[2] = '0' + gesplitst[2];
    }

    String reassemble = gesplitst[0] + "-" + gesplitst[1] + "-" + gesplitst[2];
    DateTime result = DateTime.parse(reassemble);
    return result;
  }

  String get getDateString {
    return datum;
  }

  double get getRating {
    return rating;
  }

  String get getComment {
    return opmerking;
  }

  List<String> get getTagList {
    return tags;
  }

  List<String> get getSubTagList {
    return all_sub_tags;
  }

  List<String> getSubTagsByIndex(int i) {
    String subTagText;
    for (String subtags in all_sub_tags_raw[i].getSubTagList) {}
    return all_sub_tags;
  }
}
