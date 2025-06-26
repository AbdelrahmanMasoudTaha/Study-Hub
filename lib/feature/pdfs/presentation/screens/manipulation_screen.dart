import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:study_hub/core/constants/colors.dart';
import 'package:study_hub/core/helpers/helper_functions.dart';
import 'package:study_hub/feature/ocr/presentation/Ocr_PDF/ocr_pdf.dart';
import 'package:study_hub/feature/pdfs/data/pdf_manipulation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:study_hub/feature/pdfs/logic/bloc/pdf_manipulation_bloc.dart';
import 'package:study_hub/feature/pdfs/presentation/widgets/action_card.dart';
import 'package:study_hub/feature/pdfs/presentation/widgets/dialogs.dart';
import '../widgets/pdf_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class ManipulationScreen extends StatelessWidget {
  const ManipulationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfManipulationBloc(),
      child: const _ManipulationView(),
    );
  }
}

class _ManipulationView extends StatefulWidget {
  const _ManipulationView({Key? key}) : super(key: key);

  @override
  State<_ManipulationView> createState() => _ManipulationViewState();
}

class _ManipulationViewState extends State<_ManipulationView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MyHelperFunctions.isDarkMode(context);
    return BlocListener<PdfManipulationBloc, PdfManipulationState>(
      listener: (context, state) {
        if (state is PdfManipulationLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is PdfMergeReadyForSaving) {
          setState(() {
            _isLoading = false;
          });
          PdfDialogs.showFileNameDialog(context, 'Name Your Merged PDF')
              .then((fileName) {
            if (fileName != null && fileName.isNotEmpty) {
              context.read<PdfManipulationBloc>().add(
                    SaveMergedPdfRequested(state.temporaryFile, fileName),
                  );
            }
          });
        } else if (state is PdfManipulationSuccess) {
          setState(() {
            _isLoading = false;
          });
          _showSuccessMessage(context, state.message, state.path);
        } else if (state is PdfManipulationFailure) {
          setState(() {
            _isLoading = false;
          });
          _showMessage(context, state.error);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('PDF Manipulation'),
              iconTheme: IconThemeData(
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ActionCard(
                      title: 'Open PDF',
                      description: 'Open a PDF file from your device',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PdfScreen(),
                          ),
                        );
                      },
                      color: MyColors.buttonPrimary,
                      icon: Icons.picture_as_pdf_outlined,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'Merge PDFs',
                      description: 'Combine multiple PDF files into one',
                      onPressed: () async {
                        if (Theme.of(context).platform ==
                            TargetPlatform.android) {
                          var status = await Permission.storage.status;
                          if (!status.isGranted) {
                            status = await Permission.storage.request();
                          }
                          if (!status.isGranted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Storage permission is required to merge PDFs.')),
                            );
                            return;
                          }
                        }
                        context
                            .read<PdfManipulationBloc>()
                            .add(MergePdfsRequested());
                      },
                      color: Colors.green,
                      icon: Icons.merge_type,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'Split PDF',
                      description: 'Split a PDF file into two parts',
                      onPressed: () async {
                        final pdfManipulation = PdfManipulation();
                        final pdfFile =
                            await pdfManipulation.pickSinglePdfFile();
                        if (pdfFile == null) return;

                        final splitOptions =
                            await PdfDialogs.showSplitOptionsDialog(context);
                        if (splitOptions != null) {
                          context.read<PdfManipulationBloc>().add(
                                SplitPdfRequested(
                                  pdfFile: pdfFile,
                                  startPage: splitOptions['startPage']!,
                                  endPage: splitOptions['endPage']!,
                                  fileName: splitOptions['fileName']!,
                                ),
                              );
                        }
                      },
                      color: MyColors.orangeClr,
                      icon: Icons.call_split,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'Photos to PDF',
                      description: 'Create a PDF from selected photos',
                      onPressed: () async {
                        final pdfManipulation = PdfManipulation();
                        final photos = await pdfManipulation.pickPhotos();
                        if (photos == null || photos.isEmpty) return;

                        final fileName = await PdfDialogs.showFileNameDialog(
                            context, 'Name Your Photo PDF');
                        if (fileName != null && fileName.isNotEmpty) {
                          context.read<PdfManipulationBloc>().add(
                                CreatePdfFromPhotosRequested(
                                  photos: photos,
                                  fileName: fileName,
                                ),
                              );
                        }
                      },
                      color: MyColors.pinkClr,
                      icon: Icons.photo_library,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'PDF to Text',
                      description: 'Extract text from PDF',
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OcrPdfScreen(),
                            ));
                      },
                      color: Color.fromARGB(255, 36, 177, 175),
                      icon: Icons.text_format,
                    ),
                    const SizedBox(height: 16),
                    ActionCard(
                      title: 'PDFs Location',
                      description: 'Show the location of your saved PDF files',
                      onPressed: () => _openPdfFolder(context),
                      color: Colors.purple,
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MyColors.buttonPrimary,
                  size: 60,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openPdfFolder(BuildContext context) async {
    final pdfManipulation = PdfManipulation();
    final folderPath = await pdfManipulation.getStorageDirectory();
    if (folderPath == null) {
      _showMessage(context, 'Could not access the PDF folder');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Folder Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your PDFs are saved in:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(folderPath),
            const SizedBox(height: 16),
            const Text(
              'To access your PDFs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Open your device\'s file manager'),
            const Text('2. Navigate to Internal Storage'),
            const Text('3. Look for the "PDF_Manipulator" folder'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
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

  void _showSuccessMessage(
      BuildContext context, String message, String? filePath) {
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
}
