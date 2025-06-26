import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:study_hub/feature/notes/data/task_model.dart';
import 'package:study_hub/feature/notes/logic/controller/note_controller.dart';
import 'package:study_hub/feature/notes/presentation/widget/note_tile.dart';
//import 'package:Notey/services/notification_services%20from%20course.dart';

import '../../../core/constants/size_config.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widget/mybutton.dart';

import 'add_note_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();
    _NoteController.getNotes();
  }

  final NoteController _NoteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          'Your Notes',
          style: headingStyle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _addNoteBar(),
            _showNotes(),
          ],
        ),
      ),
    );
  }

  Widget _addNoteBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 14, bottom: 8, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            lable: '+ Add Note',
            onTap: () async {
              await Get.to(() => const AddNoteScreen());
              //ThemeServices().switchMode();

              _NoteController.getNotes();
            },
          )
        ],
      ),
    );
  }

  Future<void> onRefresh() async {
    _NoteController.getNotes();
  }

  _showNotes() {
    return Expanded(
      child: Obx(
        () {
          if (_NoteController.Notes_listt.isEmpty) {
            return _noNoteMsg();
          } else {
            return RefreshIndicator(
              onRefresh: onRefresh,
              color: MyColors.primaryClr,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var Note = _NoteController.Notes_listt[index];
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 700),
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onLongPress: () {
                            _showBottomSheet(
                              context,
                              Note,
                            );
                          },
                          child: NoteTile(
                            Note,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _NoteController.Notes_listt.length,
              ),
            );
          }
        },
      ),
    );
  }

  _buildButtomSheet({
    required String lable,
    required Function() onTap,
    required Color clr,
    bool isClosed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClosed
                  ? Get.isDarkMode
                      ? Colors.grey[200]!
                      : Colors.grey[600]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClosed ? Colors.transparent : clr),
        child: Center(
          child: Text(lable,
              style: isClosed
                  ? titleStyle
                  : titleStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Note Note) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.screenHeight * 0.6),
        color: Get.isDarkMode ? MyColors.darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
            ),
            _buildButtomSheet(
              lable: 'Delete',
              onTap: () {
                _NoteController.deleteNote(note: Note);

                Get.back();
              },
              clr: Colors.red,
            ),
            Divider(
              color: Get.isDarkMode
                  ? const Color.fromARGB(255, 204, 194, 194)
                  : const Color.fromARGB(255, 206, 197, 197),
              endIndent: 20,
              indent: 20,
            ),
            _buildButtomSheet(
              lable: 'Update',
              onTap: () {
                _showUpdateDialog(context, Note);
              },
              clr: MyColors.bluishClr,
            ),
            Divider(
              color: Get.isDarkMode
                  ? const Color.fromARGB(255, 204, 194, 194)
                  : const Color.fromARGB(255, 206, 197, 197),
              endIndent: 20,
              indent: 20,
            ),
            _buildButtomSheet(
                lable: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: Colors.grey),
          ],
        ),
      ),
    ));
  }

  _showUpdateDialog(BuildContext context, Note note) {
    final TextEditingController _titleController =
        TextEditingController(text: note.title);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Center(child: Text("Update Note", style: headingStyle)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter a new title for your note.", style: subTitleStyle),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter new title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (_titleController.text.isNotEmpty) {
                  _NoteController.updateNote(
                    note: Note(
                      id: note.id,
                      title: _titleController.text,
                      note: note.note,
                      color: note.color,
                    ),
                  );
                  Get.back(); // Close dialog
                  Get.back(); // Close bottom sheet
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: titleStyle),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryClr,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(120, 48),
            ),
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                _NoteController.updateNote(
                  note: Note(
                    id: note.id,
                    title: _titleController.text,
                    note: note.note,
                    color: note.color,
                  ),
                );
                Get.back(); // Close dialog
                Get.back(); // Close bottom sheet
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  _noNoteMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 950),
          child: RefreshIndicator(
            color: MyColors.primaryClr,
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(
                          height: 230,
                        ),
                  SvgPicture.asset(
                    'assets/images/Note.svg',
                    semanticsLabel: 'Note',
                    color: MyColors.primaryClr.withOpacity(0.65),
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any Notes yet! \n Add new Notes to make your day prefect',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
