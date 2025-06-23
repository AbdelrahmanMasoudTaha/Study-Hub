part of 'text_to_speech_bloc.dart';

@immutable
abstract class TextToSpeechState {}

class TextToSpeechInitial extends TextToSpeechState {}

class TextToSpeechLoading extends TextToSpeechState {}

class TextToSpeechSuccess extends TextToSpeechState {
  final Uint8List audioData;

  TextToSpeechSuccess(this.audioData);
}

class TextToSpeechFailure extends TextToSpeechState {
  final String error;

  TextToSpeechFailure(this.error);
}
