import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  final double currentDuration;
  final double selectedTime;
  final bool timerPlaying;
  final int rounds;
  final int goal;
  final String currentState;

  const TimerState({
    required this.currentDuration,
    required this.selectedTime,
    required this.timerPlaying,
    required this.rounds,
    required this.goal,
    required this.currentState,
  });

  factory TimerState.initial() => const TimerState(
    currentDuration: 1500,
    selectedTime: 1500,
    timerPlaying: false,
    rounds: 0,
    goal: 0,
    currentState: "FOCUS",
  );

  TimerState copyWith({
    double? currentDuration,
    double? selectedTime,
    bool? timerPlaying,
    int? rounds,
    int? goal,
    String? currentState,
  }) {
    return TimerState(
      currentDuration: currentDuration ?? this.currentDuration,
      selectedTime: selectedTime ?? this.selectedTime,
      timerPlaying: timerPlaying ?? this.timerPlaying,
      rounds: rounds ?? this.rounds,
      goal: goal ?? this.goal,
      currentState: currentState ?? this.currentState,
    );
  }

  @override
  List<Object?> get props => [
    currentDuration,
    selectedTime,
    timerPlaying,
    rounds,
    goal,
    currentState,
  ];
}
