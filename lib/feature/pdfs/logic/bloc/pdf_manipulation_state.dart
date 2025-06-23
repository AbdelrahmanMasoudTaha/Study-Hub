part of 'pdf_manipulation_bloc.dart';

@immutable
abstract class PdfManipulationState {}

class PdfManipulationInitial extends PdfManipulationState {}

class PdfManipulationLoading extends PdfManipulationState {}

class PdfMergeReadyForSaving extends PdfManipulationState {
  final dynamic temporaryFile;

  PdfMergeReadyForSaving(this.temporaryFile);
}

class PdfManipulationSuccess extends PdfManipulationState {
  final String message;
  final String? path;

  PdfManipulationSuccess({required this.message, this.path});
}

class PdfManipulationFailure extends PdfManipulationState {
  final String error;

  PdfManipulationFailure(this.error);
}
