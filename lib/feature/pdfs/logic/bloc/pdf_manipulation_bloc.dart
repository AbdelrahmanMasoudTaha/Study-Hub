import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_hub/feature/pdfs/data/pdf_manipulation.dart';

part 'pdf_manipulation_event.dart';
part 'pdf_manipulation_state.dart';

class PdfManipulationBloc
    extends Bloc<PdfManipulationEvent, PdfManipulationState> {
  final PdfManipulation _pdfManipulation = PdfManipulation();

  PdfManipulationBloc() : super(PdfManipulationInitial()) {
    on<MergePdfsRequested>(_onMergePdfsRequested);
    on<SaveMergedPdfRequested>(_onSaveMergedPdfRequested);
    on<SplitPdfRequested>(_onSplitPdfRequested);
    on<CreatePdfFromPhotosRequested>(_onCreatePdfFromPhotosRequested);
  }

  Future<void> _onMergePdfsRequested(
      MergePdfsRequested event, Emitter<PdfManipulationState> emit) async {
    emit(PdfManipulationLoading());
    try {
      final files = await _pdfManipulation.pickPdfFiles();
      if (files == null || files.isEmpty) {
        emit(PdfManipulationFailure('No PDFs selected'));
        return;
      }
      if (files.length < 2) {
        emit(PdfManipulationFailure('Please select at least 2 PDFs to merge'));
        return;
      }

      final result = await _pdfManipulation.mergePdfsToTemp(files);

      if (result != null) {
        emit(PdfMergeReadyForSaving(result));
      } else {
        emit(PdfManipulationFailure('Failed to merge PDFs'));
      }
    } catch (e) {
      emit(PdfManipulationFailure('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onSaveMergedPdfRequested(
      SaveMergedPdfRequested event, Emitter<PdfManipulationState> emit) async {
    emit(PdfManipulationLoading());
    try {
      final result = await _pdfManipulation.savePdfToPublicDirectory(
          event.temporaryFile, event.fileName);
      if (result != null) {
        emit(PdfManipulationSuccess(
            message: 'PDF saved successfully!', path: result.path));
      } else {
        emit(PdfManipulationFailure('Failed to save PDF'));
      }
    } catch (e) {
      emit(PdfManipulationFailure('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onSplitPdfRequested(
      SplitPdfRequested event, Emitter<PdfManipulationState> emit) async {
    emit(PdfManipulationLoading());
    try {
      final result = await _pdfManipulation.splitPdf(
          event.pdfFile, event.startPage, event.endPage, event.fileName);
      if (result != null) {
        emit(PdfManipulationSuccess(
          message:
              'PDF split successfully!\nExtracted pages ${event.startPage} to ${event.endPage}',
          path: result.path,
        ));
      } else {
        emit(PdfManipulationFailure('Failed to split PDF'));
      }
    } catch (e) {
      emit(PdfManipulationFailure('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePdfFromPhotosRequested(
      CreatePdfFromPhotosRequested event,
      Emitter<PdfManipulationState> emit) async {
    emit(PdfManipulationLoading());
    try {
      if (event.photos.isEmpty) {
        emit(PdfManipulationFailure('No photos selected'));
        return;
      }
      final result = await _pdfManipulation.createPdfFromPhotos(
          event.photos, event.fileName);
      if (result != null) {
        emit(PdfManipulationSuccess(
            message: 'PDF created successfully!', path: result.path));
      } else {
        emit(PdfManipulationFailure('Failed to create PDF from photos'));
      }
    } catch (e) {
      emit(PdfManipulationFailure('An error occurred: ${e.toString()}'));
    }
  }
}
