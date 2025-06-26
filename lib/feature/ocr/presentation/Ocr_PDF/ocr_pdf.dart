import 'dart:convert';
import 'dart:developer' as io;
import 'package:study_hub/core/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:study_hub/core/widget/custom_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OcrPdfScreen extends StatefulWidget {
  const OcrPdfScreen({super.key});

  @override
  _OcrPdfScreenState createState() => _OcrPdfScreenState();
}

class _OcrPdfScreenState extends State<OcrPdfScreen> {
  String _extractedText = ''; // Variable to store extracted text
  bool _isLoading = false; // Show loader during PDF processing
  final ScrollController _resultScrollController = ScrollController();

  @override
  void dispose() {
    _resultScrollController.dispose();
    super.dispose();
  }

  // Function to pick a PDF file
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      // Get the picked file
      PlatformFile file = result.files.first;
      _uploadPdfFile(file); // Upload and extract text from PDF
    }
  }

  // Function to upload the PDF file and extract text
  Future<void> _uploadPdfFile(PlatformFile file) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Assuming the server is running on localhost at port 5000
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.6:5000/ocr/extract_text'),
        // Uri.parse('https://cd6f-41-37-182-95.ngrok-free.app/ocr/extract_text'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path!),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        // Check if 'text' exists and is not null
        if (jsonResponse['text'] != null) {
          setState(() {
            _extractedText = jsonResponse['text'];
          });
        } else {
          setState(() {
            _extractedText = 'No text extracted from the PDF.';
          });
        }
      } else {
        var responseBody = await response.stream.bytesToString();
        io.log(
            'Error: ${response.statusCode} - $responseBody'); // Log the error response
        setState(() {
          _extractedText = 'Failed to extract text from the PDF.';
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

  // Function to copy extracted text to clipboard
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
        title: Text(
          "PDF to Text",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.buttonPrimary,
            fontSize: MediaQuery.of(context).size.width * 0.08,
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
                  // PDF Upload button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomButton(
                        label: "Upload PDF", onPressed: _pickPdfFile),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  // Display extracted text or a placeholder message
                  Container(
                    width: MediaQuery.of(context).size.height * 0.50,
                    height: MediaQuery.of(context).size.height * 0.25,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                        controller: _resultScrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: SingleChildScrollView(
                          controller: _resultScrollController,
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
                                        : Colors.black87,
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
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
