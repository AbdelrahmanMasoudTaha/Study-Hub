// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/feature/notes/data/task_model.dart';
import 'package:study_hub/feature/notes/logic/controller/note_controller.dart';

import '../../../core/Model/task_model.dart';
import '../../to_do/logic/controller/task_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widget/my_input_field.dart';
import '../../../core/widget/mybutton.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddNoteScreen> {
  final NoteController _theMainNoteController = Get.put(NoteController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  // ignore: unused_field, prefer_final_fields

  int _selctedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Note',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalet(),
                  MyButton(
                      lable: 'Creat Note',
                      onTap: () {
                        _validateTask();
                        if (_noteController.text.isNotEmpty &&
                            _titleController.text.isNotEmpty) {
                          Get.back();
                        }
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        // backgroundColor: context.theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 8.0),
        //     child: CircleAvatar(
        //       backgroundImage: AssetImage('assets/images/person.jpeg'),
        //       radius: 24,
        //     ),
        //   ),
        // ],
      );

  _validateTask() {
    if (_noteController.text.isNotEmpty && _titleController.text.isNotEmpty) {
      _addNoteToDb();
    } else if (_noteController.text.isEmpty || _titleController.text.isEmpty) {
      Get.snackbar('Required Feild', "Please Fill All Feilds",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      log('#########   the task dose not saved successfully   #########');
    }
  }

  _addNoteToDb() async {
    await _theMainNoteController.addNote(
        note: Note(
      title: _titleController.text,
      note: _noteController.text,
      color: _selctedColor,
    ));
  }

  Column _colorPalet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selctedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: index == 0
                      ? MyColors.primaryClr
                      : index == 1
                          ? MyColors.pinkClr
                          : MyColors.orangeClr,
                  child: _selctedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
