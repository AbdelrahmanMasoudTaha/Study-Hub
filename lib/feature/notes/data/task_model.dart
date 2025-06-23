import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Note {
  int? id;
  String? title;
  String? note;

  int? color;
  Note({
    this.id,
    this.title,
    this.note,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'color': color
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      color: map['color'] != null ? map['color'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}
