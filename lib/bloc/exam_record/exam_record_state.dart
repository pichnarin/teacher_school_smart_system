import 'package:equatable/equatable.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';

enum ExamRecordStatus { initial, loading, loaded, error, patching, patched, setting, set }

enum ExamScoreSetStatus { initial, loading, set, notSet, error }

class ExamRecordState extends Equatable {
  final ExamRecordStatus status;
  final List<ScoreWithStudent> scores;
  final String? errorMessage;

  // New fields for exam score set check
  final ExamScoreSetStatus scoreSetStatus;
  final String? scoreSetError;

  const ExamRecordState({
    this.status = ExamRecordStatus.initial,
    this.scores = const [],
    this.errorMessage,
    this.scoreSetStatus = ExamScoreSetStatus.initial,
    this.scoreSetError,
  });

  ExamRecordState copyWith({
    ExamRecordStatus? status,
    List<ScoreWithStudent>? scores,
    String? errorMessage,
    ExamScoreSetStatus? scoreSetStatus,
    String? scoreSetError,
  }) {
    return ExamRecordState(
      status: status ?? this.status,
      scores: scores ?? this.scores,
      errorMessage: errorMessage ?? this.errorMessage,
      scoreSetStatus: scoreSetStatus ?? this.scoreSetStatus,
      scoreSetError: scoreSetError ?? this.scoreSetError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    scores,
    errorMessage,
    scoreSetStatus,
    scoreSetError,
  ];
}

