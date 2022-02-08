class Tag {
  List<dynamic> subTags;
  Tag(this.subTags);
  factory Tag.fromJson(Map<String, dynamic> parsedJson) {
    List<String> tags = [];
    for (String subtag in parsedJson['sub_tags']) {
      tags.add("\"$subtag\"");
    }
    return Tag(parsedJson['sub_tags']);
  }
  @override
  String toString() {
    List<String> stringlist = [];
    for (dynamic subtag in subTags) {
      stringlist.add("\"$subtag\"");
    }
    return '{"sub_tags": $stringlist}';
  }

  List<dynamic> get getSubTagList {
    return subTags;
  }
}