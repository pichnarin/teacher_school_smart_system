
import '../../data/model/class.dart';

enum ClassStatus{
  initial,
  loading,
  loaded,
  error
}

class ClassState {
  final ClassStatus status;
  final String? errorMessage;
  final List<Class>? classes;
  final String? selectedDate;
  final List<Class>? classFilterByDate;
  final String? classId;
  final List<Class>? classFilterById;


  const ClassState({
    this.status = ClassStatus.initial,
    this.errorMessage,
    this.classes,
    this.selectedDate,
    this.classFilterByDate,
    this.classId,
    this.classFilterById,

  });

  ClassState copyWith({
    ClassStatus? status,
    String? errorMessage,
    List<Class>? classes,
    String? selectedDate,
    List<Class>? classFilterByDate,
    String? classId,
    List<Class>? classFilterById,
  }) {
    return ClassState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      classes: classes ?? this.classes,
      selectedDate: selectedDate ?? this.selectedDate,
      classFilterByDate: classFilterByDate ?? this.classFilterByDate,
      classId: classId ?? this.classId,
      classFilterById: classFilterById ?? this.classFilterById,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, classes, selectedDate, classFilterByDate, classId, classFilterById];
}