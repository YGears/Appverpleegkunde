import 'package:intl/intl.dart';
import 'tag.dart';

class DailyReflection {
  String date;
  double rating;
  String comment;
  List<dynamic> tag;
  List<Tag> unparsedSubtags = [];
  List<String> parsedSubtags = [];
  List<String> tags = [];
  DailyReflection(
      this.date, this.rating, this.comment, this.tag, this.unparsedSubtags);
  factory DailyReflection.fromJson(Map<String, dynamic> parsedJson) {
    List<Tag> ref = [];
    if (parsedJson['all_sub_tags'] != null) {
      for (Map<String, dynamic> item in parsedJson['all_sub_tags']) {
        ref.add(Tag.fromJson(item));
      }
    }
    return DailyReflection(parsedJson['datum'], parsedJson['rating'].toDouble(),
        parsedJson['opmerking'], parsedJson['tag'], ref);
  }
  @override
  String toString() {
    tags = [];
    for (Tag unparsedSubtag in unparsedSubtags) {
      parsedSubtags.add(unparsedSubtag.toString());
    }
    for (dynamic subtags in tag) {
      tags.add("\"$subtags\"");
    }
    return '{ "datum": "$date", "rating": ${rating.toInt()}, "opmerking": "$comment", "tag": ${tags.toString()}, "all_sub_tags": $parsedSubtags}';
  }

  DateTime get getDate {
    return DateFormat("dd/MM/yyyy").parse(date);
  }

  DateTime get getDateType {
    List<String> gesplitst = date.split('/');
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
    return date;
  }

  double get getRating {
    return rating;
  }

  String get getComment {
    return comment;
  }

  List<String> get getTagList {
    return tags;
  }

  List<String> get getSubTagList {
    return parsedSubtags;
  }

  String getSubTagsByIndex(int i) {
    String subTagText = "";
    if (unparsedSubtags.isEmpty) {
      return subTagText;
    }
    if (unparsedSubtags.length - 1 < i) {
      return subTagText;
    }
    for (String subtags in unparsedSubtags[i].getSubTagList) {
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
    return tags[i];
  }
}
