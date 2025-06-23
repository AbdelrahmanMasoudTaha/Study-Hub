import 'package:get/get.dart';
import 'package:study_hub/feature/notes/data/db/db_note_hellper.dart';
import 'package:study_hub/feature/notes/data/task_model.dart';

class NoteController extends GetxController {
  final RxList<Note> Notes_listt = <Note>[].obs;

  getNotes() async {
    final List<Map<String, dynamic>> Notes = await DbNoteHelper.query();
    Notes_listt.assignAll(
        Notes.map((NoteData) => Note.fromMap(NoteData)).toList());
  }

  Future<int> addNote({required Note note}) {
    var intReturned = DbNoteHelper.insert(note);
    return intReturned;
  }

  deleteNote({required Note note}) async {
    await DbNoteHelper.delete(note);
    getNotes();
  }

  updateNote({required Note note}) async {
    await DbNoteHelper.updateNote(note);
    getNotes();
  }

  deleteAllNotes() async {
    await DbNoteHelper.deleteAll();
    getNotes();
  }
}
