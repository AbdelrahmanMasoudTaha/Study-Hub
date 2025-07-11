import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/feature/promodoro/logic/timer_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_state.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              state.currentState,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.white.withOpacity(0.8),
                        spreadRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (state.currentDuration ~/ 60).toString(),
                      style: TextStyle(
                        color: renderColor(state.currentState),
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.white.withOpacity(0.8),
                        spreadRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (state.currentDuration % 60) == 0
                          ? "${(state.currentDuration % 60).round()}0"
                          : (state.currentDuration % 60).round().toString(),
                      style: TextStyle(
                        color: renderColor(state.currentState),
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Color renderColor(String currentState) {
  if (currentState == "FOCUS") {
    return MyColors.bluishClr;
  } else {
    return MyColors.success;
  }
}
