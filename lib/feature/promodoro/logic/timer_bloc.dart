import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;

  TimerBloc() : super(TimerState.initial()) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<TimerTimeSelected>(_onTimeSelected);
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    if (state.timerPlaying) return;
    _timer?.cancel();
    emit(state.copyWith(timerPlaying: true));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(TimerTicked());
    });
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(timerPlaying: false));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(TimerState.initial());
  }

  void _onTimeSelected(TimerTimeSelected event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(
      state.copyWith(
        selectedTime: event.seconds,
        currentDuration: event.seconds,
        timerPlaying: false,
      ),
    );
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (state.currentDuration == 0) {
      _handleNextRound(emit);
    } else {
      emit(state.copyWith(currentDuration: state.currentDuration - 1));
    }
  }

  void _handleNextRound(Emitter<TimerState> emit) {
    if (state.currentState == "FOCUS" && state.rounds != 3) {
      emit(
        state.copyWith(
          currentState: "BREAK",
          currentDuration: 300,
          selectedTime: 300,
          rounds: state.rounds + 1,
          goal: state.goal + 1,
        ),
      );
    } else if (state.currentState == "BREAK") {
      emit(
        state.copyWith(
          currentState: "FOCUS",
          currentDuration: 1500,
          selectedTime: 1500,
        ),
      );
    } else if (state.currentState == "FOCUS" && state.rounds == 3) {
      emit(
        state.copyWith(
          currentState: "LONG BREAK",
          currentDuration: 1500,
          selectedTime: 1500,
          rounds: state.rounds + 1,
          goal: state.goal + 1,
        ),
      );
    } else if (state.currentState == "LONG BREAK") {
      emit(
        state.copyWith(
          currentState: "FOCUS",
          currentDuration: 1500,
          selectedTime: 1500,
          rounds: 0,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
