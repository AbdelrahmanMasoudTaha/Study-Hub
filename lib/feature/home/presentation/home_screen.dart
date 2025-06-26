import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:study_hub/feature/notes/presentation/note_screen.dart';
import 'package:study_hub/feature/ocr/presentation/ocr_img_screen.dart';
import 'package:study_hub/feature/pdfs/presentation/screens/manipulation_screen.dart';
import 'package:study_hub/feature/pdfs/presentation/widgets/pdf_screen.dart';
import 'package:study_hub/feature/promodoro/logic/timer_bloc.dart';
import 'package:study_hub/feature/promodoro/presentation/screens/promodoro_screen.dart';
import 'package:study_hub/feature/summarization/presentation/summarize_screen.dart';
import 'package:study_hub/feature/text_to_speach/presentation/screens/text_to_speech.dart';
import 'package:study_hub/feature/to_do/presentation/to_do_screen.dart';
import 'package:study_hub/feature/home/presentation/widgets/item_grid.dart'; // Ensure this import is correct
import 'package:iconsax/iconsax.dart';
import 'package:study_hub/feature/translation/presentation/translate_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                // Staggered Grid View
                Container(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    //mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    //crossAxisSpacing: 15,
                    children: [
                      //summartions
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 0.9,

                        /// mainAxisCellCount: 0.8,
                        child: Grid_Item_Container(
                          color: Colors.blue,
                          isSmall: true,
                          icon: Icons.summarize,
                          title: "Summarization",
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SummarizeScreen(),
                            ));
                          },
                        ),
                      ),
                      //OCR
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1.1,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const OCRImgScreen(),
                            ));
                          },
                          color: Colors.blueGrey,
                          icon: Iconsax.scanner,
                          title: "Image to Text",
                        ),
                      ),
                      //Translation
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TranslateScreen(),
                            ));
                          },
                          color: Colors.red,
                          isSmall: true,
                          icon: Iconsax.translate,
                          title: "Translation",
                        ),
                      ),
                      //pdf
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 0.9,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ManipulationScreen(),
                            ));
                          },
                          color: Colors.purple,
                          icon: Icons.picture_as_pdf_outlined,
                          title: "PDF Tools",
                        ),
                      ),
                      //  text to speech
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TextToSpeechScreen(),
                            ));
                          },
                          color: Colors.yellow,
                          isSmall: true,
                          icon: Iconsax.sound,
                          title: "Listen to Text",
                        ),
                      ),
                      //to do
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ToDoScreen(),
                            ));
                          },
                          color: Colors.green,
                          icon: Icons.task_alt_rounded,
                          title: "To Do",
                        ),
                      ),
                      //Pomodoro
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 0.9,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider<TimerBloc>(
                                  create: (_) => TimerBloc(),
                                  child: const PromodoroScreen(),
                                ),
                              ),
                            );
                          },
                          color: Colors.indigo,
                          icon: Icons.timer,
                          title: "Pomodoro",
                        ),
                      ),

                      //notes
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 0.8,
                        child: Grid_Item_Container(
                          function: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NoteScreen(),
                            ));
                          },
                          color: Colors.orange,
                          isSmall: true,
                          icon: Iconsax.note,
                          title: "Notes",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
