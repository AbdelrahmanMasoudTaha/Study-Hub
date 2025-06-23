import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:study_hub/feature/text_to_speach/data/text_to_speech_repository.dart';

part 'text_to_speech_event.dart';
part 'text_to_speech_state.dart';

class TextToSpeechBloc extends Bloc<TextToSpeechEvent, TextToSpeechState> {
  final TextToSpeechRepository _repository;

  TextToSpeechBloc(this._repository) : super(TextToSpeechInitial()) {
    on<TextToSpeechRequested>(_onTextToSpeechRequested);
  }

  Future<void> _onTextToSpeechRequested(
      TextToSpeechRequested event, Emitter<TextToSpeechState> emit) async {
    emit(TextToSpeechLoading());
    try {
      final audioData = await _repository.getSpeech(event.text);
      emit(TextToSpeechSuccess(audioData));
    } catch (e) {
      emit(TextToSpeechFailure(e.toString()));
    }
  }
}
