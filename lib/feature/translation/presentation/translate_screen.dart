import 'package:flutter/material.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:translator/translator.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TranslateScreen extends StatefulWidget {
  @override
  State<TranslateScreen> createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateScreen> {
  List<String> languages = [
    "Arabic",
    "German",
    "Italian",
    "Spanish",
    "English",
    "French",
  ];
  String? selectedLanguage = "English";
  String translatedText = "";
  String code = "ar";
  late TextEditingController textController;
  bool isTranslating = false;

  final GoogleTranslator _translator = GoogleTranslator();
  late final ScrollController _resultScrollController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _resultScrollController = ScrollController();
  }

  @override
  void dispose() {
    textController.dispose();
    _resultScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          "Translation",
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
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      Text(
                        "Translate to",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: MediaQuery.of(context).size.width * 0.08,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            value: selectedLanguage,
                            items: languages.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(
                                  language,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLanguage = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  // Input Field
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
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      minLines: 5,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Enter text to translate",
                        hintStyle: TextStyle(
                            color: (isDarkMode ? Colors.white : Colors.black)
                                .withOpacity(0.6)),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: MaterialButton(
                      onPressed: isTranslating
                          ? null
                          : () async {
                              if (selectedLanguage == 'Arabic') {
                                code = "ar";
                              } else if (selectedLanguage == 'German') {
                                code = "de";
                              } else if (selectedLanguage == 'Italian') {
                                code = "it";
                              } else if (selectedLanguage == 'English') {
                                code = "en";
                              } else if (selectedLanguage == 'French') {
                                code = "fr";
                              } else {
                                code = "es";
                              }

                              setState(() {
                                isTranslating = true;
                              });

                              await translate(code, textController.text);

                              setState(() {
                                isTranslating = false;
                              });
                            },
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
                      child: Text(
                        "Translate",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  // Result Area
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
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
                        thumbColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
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
                            translatedText,
                            textDirection: selectedLanguage == 'Arabic'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isTranslating)
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

  Future<void> translate(String code, String text) async {
    try {
      Translation translation = await _translator.translate(text, to: code);
      setState(() {
        translatedText = translation.text;
      });
    } catch (e) {
      print('Translation failed: $e');
      translatedText = "";
    }
  }
}
