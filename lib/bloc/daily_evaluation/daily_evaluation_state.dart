import 'package:equatable/equatable.dart';
import '../../data/model/dto/daily_evaluation_dto.dart';

enum DailyEvaluationStatus {
  initial,
  loading,
  loaded,
  error,
  creating,
  created,
  patching,
  patched,
  checkingExist,
  existChecked,
}

class DailyEvaluationState extends Equatable {
  final DailyEvaluationStatus status;
  final String? errorMessage;
  final List<DailyEvaluationDTO>? dailyEvaluations;
  final bool? exists;

  const DailyEvaluationState({
    this.status = DailyEvaluationStatus.initial,
    this.errorMessage,
    this.dailyEvaluations,
    this.exists,
  });

  DailyEvaluationState copyWith({
    DailyEvaluationStatus? status,
    String? errorMessage,
    List<DailyEvaluationDTO>? dailyEvaluations,
    bool? exists,
  }) {
    return DailyEvaluationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      dailyEvaluations: dailyEvaluations ?? this.dailyEvaluations,
      exists: exists ?? this.exists,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, dailyEvaluations, exists];
}
