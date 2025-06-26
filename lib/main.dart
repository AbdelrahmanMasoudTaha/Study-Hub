import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/app.dart';
import 'package:study_hub/feature/notes/data/db/db_note_hellper.dart';
import 'package:study_hub/firebase_options.dart';
import 'package:flutter/services.dart';

import 'core/db/db_hellper.dart';
// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await DbHelper.initDb();
  await DbNoteHelper.initDb();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const App(),
  );
  runApp(const App());
}
