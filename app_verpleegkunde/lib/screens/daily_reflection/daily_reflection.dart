class daily_reflection{

String date;
int rating;
String comment;
List tag;
List subtag;

daily_reflection(this.date, this.rating, this.comment, this.tag, this.subtag);

factory daily_reflection.fromJson(dynamic json){
  return daily_reflection(
    json['datum'] as String,
    json['rating'] as int,
    json['opmerking'] as String,
    json['tag'] as List,
    json['all_sub_tags'] as List,
    );
}

@override
String toString(){
  return 'Reflectie: $date, $rating, $comment, $tag, $subtag';
}

}