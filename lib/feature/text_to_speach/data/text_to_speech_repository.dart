import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TextToSpeechRepository {
  final Dio _dio = Dio();
  final String _endpoint = 'http://192.168.1.6:5000/models/text_to_speech';

  Future<Uint8List> getSpeech(String text) async {
    try {
      final response = await _dio.post(
        _endpoint,
        data: {
          'sentences': [text]
        },
        options: Options(
          responseType: ResponseType.bytes, // Important for file response
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load audio');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
