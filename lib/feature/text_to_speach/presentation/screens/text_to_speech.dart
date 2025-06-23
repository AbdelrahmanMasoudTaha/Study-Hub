import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:study_hub/core/widget/custom_button.dart';
import 'package:study_hub/feature/text_to_speach/data/text_to_speech_repository.dart';
import 'package:study_hub/feature/text_to_speach/logic/bloc/text_to_speech_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class TextToSpeechScreen extends StatelessWidget {
  const TextToSpeechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextToSpeechBloc(TextToSpeechRepository()),
      child: const _TextToSpeechView(),
    );
  }
}

class _TextToSpeechView extends StatefulWidget {
  const _TextToSpeechView();

  @override
  State<_TextToSpeechView> createState() => _TextToSpeechViewState();
}

class _TextToSpeechViewState extends State<_TextToSpeechView> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Speech'),
      ),
      body: BlocConsumer<TextToSpeechBloc, TextToSpeechState>(
        listener: (context, state) {
          if (state is TextToSpeechFailure) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Error',
                message: state.error,
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          final isLoading = state is TextToSpeechLoading;

          Widget actionButton;
          if (state is TextToSpeechLoading) {
            actionButton = _buildLoadingIndicator();
          } else if (state is TextToSpeechSuccess) {
            actionButton = Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: VoicePlayer(audioData: state.audioData),
            );
          } else {
            actionButton = _buildGenerateButton();
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Enter text to generate speech',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _textController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Type something here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      actionButton,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Enter text to convert to speech...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        final text = _textController.text.trim();
        if (text.isNotEmpty) {
          context.read<TextToSpeechBloc>().add(TextToSpeechRequested(text));
        }
      },
      icon: const Icon(Icons.speaker_phone, color: Colors.white),
      label:
          const Text('Generate Speech', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: MyColors.bluishClr,
        size: 60,
      ),
    );
  }
}

class VoicePlayer extends StatefulWidget {
  final Uint8List audioData;
  const VoicePlayer({super.key, required this.audioData});

  @override
  State<VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _playerState;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isSeeking = false;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isCompleted => _playerState == PlayerState.completed;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (_isSeeking || !mounted) return;
      setState(() => _position = position);
    });

    _audioPlayer.setSourceBytes(widget.audioData).then((_) {
      _audioPlayer.resume();
    });
  }

  Future<void> _play() async {
    if (_isCompleted) {
      await _audioPlayer.play(BytesSource(widget.audioData));
    } else {
      await _audioPlayer.resume();
    }
  }

  Future<void> _pause() async {
    await _audioPlayer.pause();
  }

  void _rewind() {
    final newPosition = _position - const Duration(seconds: 10);
    _audioPlayer.seek(newPosition.isNegative ? Duration.zero : newPosition);
  }

  void _forward() {
    final newPosition = _position + const Duration(seconds: 10);
    _audioPlayer.seek(newPosition > _duration ? _duration : newPosition);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _downloadAudio() async {
    try {
      if (Platform.isAndroid) {
        final permissions = await Permission.storage.request();
        if (!permissions.isGranted) {
          _showErrorSnackbar(
              'Storage permission is required to download files.');
          return;
        }
      }

      final directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath == null) {
        // User canceled the picker
        return;
      }

      final fileName = await _showFileNameDialog(context);
      if (fileName == null || fileName.isEmpty) {
        return;
      }

      final filePath = '$directoryPath/$fileName.wav';
      final file = File(filePath);
      await file.writeAsBytes(widget.audioData);

      _showSuccessSnackbar('Audio downloaded successfully to $filePath');
    } catch (e) {
      _showErrorSnackbar('Failed to download audio: $e');
    }
  }

  Future<String?> _showFileNameDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Audio As...'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter file name"),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success',
        message: message,
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Voice Output',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Slider(
            activeColor: MyColors.bluishClr,
            min: 0,
            max: _duration.inMilliseconds.toDouble(),
            value: _position.inMilliseconds
                .toDouble()
                .clamp(0.0, _duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              final newPosition = Duration(milliseconds: value.round());
              setState(() {
                _position = newPosition;
              });
            },
            onChangeStart: (value) {
              setState(() {
                _isSeeking = true;
              });
            },
            onChangeEnd: (value) async {
              final newPosition = Duration(milliseconds: value.round());
              await _audioPlayer.seek(newPosition);
              setState(() {
                _isSeeking = false;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_position.toString().split('.').first.padLeft(8, '0')),
                Text(_duration.toString().split('.').first.padLeft(8, '0')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 32,
                onPressed: _rewind,
                icon: const Icon(Icons.replay_10),
              ),
              IconButton(
                iconSize: 64,
                onPressed: _isPlaying ? _pause : _play,
                icon: Icon(_isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled),
                color: MyColors.bluishClr,
              ),
              IconButton(
                iconSize: 32,
                onPressed: _forward,
                icon: const Icon(Icons.forward_10),
              ),
            ],
          ),
          const SizedBox(height: 30),
          CustomButton(label: "Download", onPressed: _downloadAudio)
        ],
      ),
    );
  }
}
