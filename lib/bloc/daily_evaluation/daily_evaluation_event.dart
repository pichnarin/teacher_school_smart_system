import 'package:equatable/equatable.dart';
import '../../data/model/dto/daily_evaluation_dto.dart';

abstract class DailyEvaluationEvent extends Equatable {
  const DailyEvaluationEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyEvaluations extends DailyEvaluationEvent {
  final String classId;
  final String sessionDate;

  const FetchDailyEvaluations(this.classId, this.sessionDate);

  @override
  List<Object?> get props => [classId, sessionDate];
}

class CheckDailyEvaluationExist extends DailyEvaluationEvent {
  final String classSessionId;

  const CheckDailyEvaluationExist(this.classSessionId);

  @override
  List<Object?> get props => [classSessionId];
}

class PatchDailyEvaluations extends DailyEvaluationEvent {
  final List<Map<String, dynamic>> payload;

  const PatchDailyEvaluations(this.payload);

  @override
  List<Object?> get props => [payload];
}

class CreateDailyEvaluations extends DailyEvaluationEvent {
  final String classSessionId;
  final List<DailyEvaluationCreateDTO> payload;

  const CreateDailyEvaluations(this.classSessionId, this.payload);

  @override
  List<Object?> get props => [classSessionId, payload];
}

