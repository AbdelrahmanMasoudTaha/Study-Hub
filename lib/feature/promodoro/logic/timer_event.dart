import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent {}

class TimerPaused extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTicked extends TimerEvent {}

class TimerTimeSelected extends TimerEvent {
  final double seconds;
  const TimerTimeSelected(this.seconds);

  @override
  List<Object?> get props => [seconds];
}
