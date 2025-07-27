import 'package:equatable/equatable.dart';
import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/data/model/score.dart';

abstract class ExamRecordEvent extends Equatable {
  const ExamRecordEvent();

  @override
  List<Object?> get props => [];
}

class FetchExamScores extends ExamRecordEvent {
  final String classId;
  final GetExamScoresFilterDto? filter;

  const FetchExamScores(this.classId, {this.filter});

  @override
  List<Object?> get props => [classId, filter];
}

class SetExamScores extends ExamRecordEvent {
  final String classId;
  final SetExamScoresDto setExamScoresDto;

  const SetExamScores(this.classId, this.setExamScoresDto);

  @override
  List<Object?> get props => [classId, setExamScoresDto];
}

class UpdateExamScore extends ExamRecordEvent {
  final String classId;
  final String examScoreId;
  final UpdateScoreDto updateScoreDto;
  final GetExamScoresFilterDto? filter;

  const UpdateExamScore(
      this.classId,
      this.examScoreId,
      this.updateScoreDto, {
        this.filter,
      });

  @override
  List<Object?> get props => [classId, examScoreId, updateScoreDto, filter];
}

class CheckExamScoreSet extends ExamRecordEvent {
  final String classId;
  final String subjectId;
  final String month;
  final String year;

  const CheckExamScoreSet(this.classId, this.subjectId, this.month, this.year);

  @override
  List<Object?> get props => [classId, subjectId, month, year];
}
