import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_state.dart';
import 'package:pat_asl_portal/data/service/exam_record_service.dart';

import '../../data/model/dto/score_dto.dart';

class ExamRecordBloc extends Bloc<ExamRecordEvent, ExamRecordState> {
  final ExamRecordService _recordService;

  ExamRecordBloc({required ExamRecordService recordService})
      : _recordService = recordService,
        super(const ExamRecordState()) {
    on<FetchExamScores>(_onFetchExamScores);
    on<SetExamScores>(_onSetExamScores);
    on<UpdateExamScore>(_onUpdateExamScore);
    on<CheckExamScoreSet>(_onCheckExamScoreSet);
  }

  void _onFetchExamScores(
      FetchExamScores event,
      Emitter<ExamRecordState> emit,
      ) async {
    emit(state.copyWith(status: ExamRecordStatus.loading));

    try {
      final scores = await _recordService.getExamScores(
        event.classId,
        filter: event.filter,
      );


      emit(state.copyWith(
        status: ExamRecordStatus.loaded,
        scores: scores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamRecordStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSetExamScores(
      SetExamScores event,
      Emitter<ExamRecordState> emit,
      ) async {
    emit(state.copyWith(status: ExamRecordStatus.loading));

    try {
      // Save the scores
      await _recordService.setExamScores(
        event.classId,
        event.setExamScoresDto,
      );

      // debugPrint("From bloc");
      // debugPrint(event.classId);
      // debugPrint(event.setExamScoresDto.toString());

      // Then fetch updated scores with filter
      final scores = await _recordService.getExamScores(
        event.classId,
        filter: GetExamScoresFilterDto(
          subjectId: event.setExamScoresDto.subjectId,
          examMonth: event.setExamScoresDto.examMonth,
          examYear: event.setExamScoresDto.examYear,
        ),
      );

      emit(state.copyWith(
        status: ExamRecordStatus.set,
        scores: scores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamRecordStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }



  void _onUpdateExamScore(
      UpdateExamScore event,
      Emitter<ExamRecordState> emit,
      ) async {
    emit(state.copyWith(status: ExamRecordStatus.loading));

    try {
      // Use service to update
      final updated = await _recordService.updateExamScore(
        event.classId,
        event.examScoreId,
        event.updateScoreDto,
      );

      // Re-fetch to get latest ScoreWithStudent data
      final refreshedScores = await _recordService.getExamScores(
        event.classId,
      );

      emit(state.copyWith(
        status: ExamRecordStatus.patched,
        scores: refreshedScores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExamRecordStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onCheckExamScoreSet(
      CheckExamScoreSet event,
      Emitter<ExamRecordState> emit,
      ) async {
    emit(state.copyWith(scoreSetStatus: ExamScoreSetStatus.loading));
    try {
      final isSet = await _recordService.isExamScoreSet(
        event.classId,
        event.subjectId,
        event.month,
        event.year,
      );
      emit(state.copyWith(
        scoreSetStatus: isSet
            ? ExamScoreSetStatus.set
            : ExamScoreSetStatus.notSet,
        scoreSetError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        scoreSetStatus: ExamScoreSetStatus.error,
        scoreSetError: e.toString(),
      ));
    }
  }

}

