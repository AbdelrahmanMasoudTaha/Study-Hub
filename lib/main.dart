import 'package:flutter/material.dart';
import 'package:study_hub/app.dart';
import 'package:study_hub/feature/notes/data/db/db_note_hellper.dart';

import 'core/db/db_hellper.dart';
// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  await DbNoteHelper.initDb();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // runApp(
  //   const App(),
  // );
  runApp(const App());
}
