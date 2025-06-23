part of 'pdf_manipulation_bloc.dart';

@immutable
abstract class PdfManipulationEvent {}

class MergePdfsRequested extends PdfManipulationEvent {}

class SaveMergedPdfRequested extends PdfManipulationEvent {
  final File temporaryFile;
  final String fileName;

  SaveMergedPdfRequested(this.temporaryFile, this.fileName);
}

class SplitPdfRequested extends PdfManipulationEvent {
  final File pdfFile;
  final int startPage;
  final int endPage;
  final String fileName;

  SplitPdfRequested({
    required this.pdfFile,
    required this.startPage,
    required this.endPage,
    required this.fileName,
  });
}

class CreatePdfFromPhotosRequested extends PdfManipulationEvent {
  final List<XFile> photos;
  final String fileName;

  CreatePdfFromPhotosRequested({required this.photos, required this.fileName});
}
