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