import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_hub/feature/notes/data/task_model.dart';

import '../../../../core/Model/task_model.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../core/constants/colors.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(
    this.note, {
    super.key,
  });
  final Note note;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
          SizeConfig.orientation == Orientation.landscape ? 6 : 16,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
        width: SizeConfig.orientation == Orientation.landscape
            ? SizeConfig.screenWidth / 2
            : SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGColor(note.color)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title!,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      )),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      note.note!,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGColor(int? color) {
    switch (color) {
      case 0:
        return MyColors.bluishClr;
      case 1:
        return MyColors.pinkClr;
      case 2:
        return MyColors.orangeClr;
      default:
        return MyColors.bluishClr;
    }
  }
}
