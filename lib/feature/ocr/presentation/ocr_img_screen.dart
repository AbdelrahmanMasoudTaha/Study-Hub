import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard support
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:study_hub/core/widget/custom_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OCRImgScreen extends StatefulWidget {
  const OCRImgScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OCRImgScreenState createState() => _OCRImgScreenState();
}

class _OCRImgScreenState extends State<OCRImgScreen> {
  File? imagefile;
  String _extractedText = '';
  final ImagePicker imagePicker = ImagePicker();
  bool _isLoading = false;
  final ScrollController _extractedScrollController = ScrollController();
  @override
  void dispose() {
    _extractedScrollController.dispose();
    super.dispose();
  }

  // Function to pick image from the camera
  // ignore: non_constant_identifier_names
  void _PickImageWithCamera() async {
    XFile? pickedfile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (pickedfile != null) {
      setState(() {
        imagefile = File(pickedfile.path);
      });
      Navigator.pop(context); // Close the dialog after picking the image
      _performTextRecognition(); // Perform OCR on the selected image
    }
  }

  // Function to pick image from the gallery
  void _PickImageWithGallery() async {
    XFile? pickedfile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (pickedfile != null) {
      setState(() {
        imagefile = File(pickedfile.path);
      });
      Navigator.pop(context); // Close the dialog after picking the image
      _performTextRecognition(); // Perform OCR on the selected image
    }
  }

  // Function to perform text recognition using ML Kit
  Future<void> _performTextRecognition() async {
    if (imagefile == null) return;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.6:5000/ocr/extract_text'),
        //Uri.parse('https://cd6f-41-37-182-95.ngrok-free.app/ocr/extract_text'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', imagefile!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['text'] != null) {
          setState(() {
            _extractedText = jsonResponse['text'];
          });

          // Haptic feedback on success
          HapticFeedback.mediumImpact();
        } else {
          setState(() {
            _extractedText = 'No text found in the image.';
          });
        }
      } else {
        setState(() {
          _extractedText = 'Failed to extract text. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Function to copy the extracted text to clipboard
  void _copyTextToClipboard() {
    if (_extractedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _extractedText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard!'),
          backgroundColor: MyColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: const Text(
          'Extract Text From Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.buttonPrimary,
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  if (imagefile != null) ...[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Image.file(imagefile!),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Button to show the dialog for selecting image source
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                        label: "Pick image", onPressed: ShowImageDialog1),
                  ),
                  const SizedBox(height: 20),
                  // Display the extracted text inside a scrollable container
                  Container(
                    width: MediaQuery.of(context).size.height * 0.5,
                    height: MediaQuery.of(context).size.height * 0.25,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: isDarkMode ? MyColors.MyDarkTheme : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          return isDarkMode ? Colors.white : Colors.grey;
                        }),
                        thickness: MaterialStateProperty.all(6),
                        radius: const Radius.circular(8),
                      ),
                      child: Scrollbar(
                        controller: _extractedScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _extractedScrollController,
                          child: _extractedText.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Extracted text will appear here.',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                )
                              : SelectableText(
                                  _extractedText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
// Copy to Clipboard button
                  if (_extractedText.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: _copyTextToClipboard,
                      icon: const Icon(Icons.copy, size: 20),
                      label: const Text('Copy Text'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),

                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MyColors.bluishClr,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Function to show the dialog to select between Camera and Gallery
  void ShowImageDialog1() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Choose an Option',
            style:
                TextStyle(color: MyColors.primary, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _PickImageWithCamera,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.camera, color: MyColors.primary),
                      SizedBox(width: 10),
                      Text(
                        'Camera',
                        style: TextStyle(color: MyColors.primary),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: _PickImageWithGallery,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.image, color: MyColors.primary),
                      SizedBox(width: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(color: MyColors.primary),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
