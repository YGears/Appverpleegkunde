import 'package:intl/intl.dart';

class Tag {
  List<dynamic> sub_tags;
  Tag(this.sub_tags);
  factory Tag.fromJson(Map<String, dynamic> parsedJson) {
    List<String> tags = [];
    for (String w in parsedJson['sub_tags']) {
      tags.add("\"$w\"");
    }
    return Tag(parsedJson['sub_tags']);
  }
  @override
  String toString() {
    List<String> stringlist = [];
    for (dynamic i in sub_tags) {
      stringlist.add("\"$i\"");
    }
    return '{"sub_tags": $stringlist}';
  }

  List<dynamic> get getSubTagList {
    return sub_tags;
  }
}

class DailyReflection {
  String datum;
  double rating;
  String opmerking;
  List<dynamic> tag;
  List<Tag> all_sub_tags_raw = [];
  List<String> all_sub_tags = [];
  List<String> tags = [];
  DailyReflection(
      this.datum, this.rating, this.opmerking, this.tag, this.all_sub_tags_raw);
  factory DailyReflection.fromJson(Map<String, dynamic> parsedJson) {
    // print(parsedJson['all_sub_tags']);
    List<Tag> ref = [];
    if (parsedJson['all_sub_tags'] != null) {
      for (Map<String, dynamic> item in parsedJson['all_sub_tags']) {
        ref.add(Tag.fromJson(item));
      }
    }
    print("ref: " + ref.toString());
    return DailyReflection(parsedJson['datum'], parsedJson['rating'].toDouble(),
        parsedJson['opmerking'], parsedJson['tag'], ref);
  }
  @override
  String toString() {
    tags = [];
    print(all_sub_tags_raw.length);
    for (Tag i in all_sub_tags_raw) {
      all_sub_tags.add(i.toString());
    }
    for (dynamic h in tag) {
      tags.add("\"$h\"");
    }
    // print(all_sub_tags);
    return '{ "datum": "$datum", "rating": ${rating.toInt()}, "opmerking": "$opmerking", "tag": ${tags.toString()}, "all_sub_tags": $all_sub_tags}';
  }

  DateTime get getDate {
    return DateFormat("dd/MM/yyyy").parse(datum);
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

  String getSubTagsByIndex(int i) {
    String subTagText = "";
    if (all_sub_tags_raw.isEmpty) {
      return subTagText;
    }
    if (all_sub_tags_raw.length - 1 < i) {
      return subTagText;
    }
    if (all_sub_tags_raw[i] == null) {
      return subTagText;
    }
    for (String subtags in all_sub_tags_raw[i].getSubTagList) {
      if (subTagText == "") {
        subTagText = subtags;
      } else {
        subTagText = subTagText + ", " + subtags;
      }
    }
    return subTagText;
  }

  String getTagsByIndex(int i) {
    if (tags.isEmpty) {
      return '';
    }
    // if (tags.length - 1 < i) {
    //   return '';
    // }
    if (tags[i] == null) {
      return '';
    }
    return tags[i];
  }
}
