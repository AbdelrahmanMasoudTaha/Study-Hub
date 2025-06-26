import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_hub/feature/promodoro/logic/timer_event.dart';
import 'package:study_hub/feature/promodoro/logic/timer_state.dart';
import 'package:study_hub/feature/promodoro/presentation/widgets/progress.dart';
import 'package:study_hub/feature/promodoro/presentation/widgets/timecontroller.dart';
import 'package:study_hub/feature/promodoro/presentation/widgets/timercard.dart';
import 'package:study_hub/feature/promodoro/presentation/widgets/timeroptions.dart';

import '../../../../core/constants/colors.dart';
import '../../logic/timer_bloc.dart';

class PromodoroScreen extends StatelessWidget {
  const PromodoroScreen({super.key});
  Color renderColor(String currentState) {
    if (currentState == "FOCUS") {
      return MyColors.bluishClr;
    } else {
      return MyColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            backgroundColor: renderColor(state.currentState),
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const TimerCard(),
                    const SizedBox(height: 30),
                    timerOptions(),
                    const SizedBox(height: 30),
                    const timeController(),
                    const SizedBox(height: 30),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerReset()),
                    ),
                    const SizedBox(height: 30),
                    const progress(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
