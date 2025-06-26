import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_event.dart';
import 'package:study_hub/feature/promodoro/logic/timer_state.dart';

class timeController extends StatelessWidget {
  const timeController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    if (state.timerPlaying) {
                      context.read<TimerBloc>().add(TimerPaused());
                    } else {
                      context.read<TimerBloc>().add(TimerStarted());
                    }
                  },
                  icon: state.timerPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow_sharp),
                  iconSize: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
