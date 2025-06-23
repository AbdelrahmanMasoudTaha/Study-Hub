class NoteModel {
  String? id;
  String? noteText;

  NoteModel({
    required this.id,
    required this.noteText,
  });

  static List<NoteModel> todoList() {
    return [];
  }
}
