part of 'text_to_speech_bloc.dart';

@immutable
abstract class TextToSpeechEvent {}

class TextToSpeechRequested extends TextToSpeechEvent {
  final String text;

  TextToSpeechRequested(this.text);
}
