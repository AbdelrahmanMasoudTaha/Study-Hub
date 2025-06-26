import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_event.dart';
import 'package:study_hub/feature/promodoro/logic/timer_state.dart';
import 'package:study_hub/feature/promodoro/presentation/widgets/timercard.dart';

class timerOptions extends StatelessWidget {
  final List<String> selectableTimes = [
    "3",
    "300",
    "600",
    "900",
    "1200",
    "1500",
    "1800",
    "2100",
    "2400",
    "2700",
    "3000",
    "3300",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return SingleChildScrollView(
          controller: ScrollController(initialScrollOffset: 155),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: selectableTimes.map((time) {
              return InkWell(
                onTap: () => context.read<TimerBloc>().add(
                      TimerTimeSelected(double.parse(time)),
                    ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 70,
                  height: 50,
                  decoration: int.parse(time) == state.selectedTime
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        )
                      : BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.white30,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                  child: Center(
                    child: Text(
                      (int.parse(time) ~/ 60).toString(),
                      style: int.parse(time) == state.selectedTime
                          ? TextStyle(
                              fontSize: 20,
                              color: renderColor(state.currentState),
                            )
                          : const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
