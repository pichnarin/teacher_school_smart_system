
import 'package:pat_asl_portal/data/model/class_session.dart';

enum ClassSessionStatus{
  initial,
  loading,
  loaded,
  error
}

class ClassSessionState {
  final ClassSessionStatus status;
  final String? errorMessage;
  final List<ClassSession>? classes;
  final String? selectedDate;
  final List<ClassSession>? classFilterByDate;
  final String? classId;
  final ClassSession? classFilterById;


  const ClassSessionState({
    this.status = ClassSessionStatus.initial,
    this.errorMessage,
    this.classes,
    this.selectedDate,
    this.classFilterByDate,
    this.classId,
    this.classFilterById,

  });

  ClassSessionState copyWith({
    ClassSessionStatus? status,
    String? errorMessage,
    List<ClassSession>? classes,
    String? selectedDate,
    List<ClassSession>? classFilterByDate,
    String? classId,
    ClassSession? classFilterById,
  }) {
    return ClassSessionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      classes:  classes ?? this.classes,
      selectedDate: selectedDate ?? this.selectedDate,
      classFilterByDate: classFilterByDate ?? this.classFilterByDate,
      classId: classId ?? this.classId,
      classFilterById: classFilterById ?? this.classFilterById,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, classes, selectedDate, classFilterByDate, classId, classFilterById];
}