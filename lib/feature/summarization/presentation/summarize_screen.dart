import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import '../data/model_sum.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SummarizeScreen extends StatefulWidget {
  const SummarizeScreen({super.key});

  @override
  State<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends State<SummarizeScreen> {
  late TextEditingController summarizeTextController;
  late final ScrollController _resultScrollController;
  String summarizedText = "";
  final SummarizeService summarizeService = SummarizeService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    summarizeTextController = TextEditingController();
    _resultScrollController = ScrollController();
  }

  @override
  void dispose() {
    summarizeTextController.dispose();
    _resultScrollController.dispose();
    super.dispose();
  }

  Future<void> summarize() async {
    final text = summarizeTextController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text to summarize")),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await summarizeService.summarizeText(text);
      setState(() {
        summarizedText = response.summary;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Failed to summarize text: $e',
            contentType: ContentType.failure,
          ),
        ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        title: Text(
          "Summarization",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.buttonPrimary,
            fontSize: MediaQuery.of(context).size.width * 0.08,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDarkMode
                            ? const Color(0xFF222222)
                            : const Color(0xFFF5F5F5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: summarizeTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        minLines: 5,
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Enter text to Summarize",
                          hintStyle: TextStyle(
                              color: (isDarkMode ? Colors.white : Colors.black)
                                  .withOpacity(0.6)),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors
                              .transparent, // Container handles background
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Center(
                      child: MaterialButton(
                        onPressed: isLoading ? null : summarize,
                        minWidth: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.08,
                        color: MyColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: isLoading
                            ? SizedBox.shrink()
                            : Text(
                                "Summarize",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            isDarkMode ? const Color(0xFF222222) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) {
                            if (isDarkMode) return Colors.white;
                            return Colors.grey;
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
                            child: SelectableText(
                              summarizedText,
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: isDarkMode ? Colors.white : MyColors.buttonPrimary,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
