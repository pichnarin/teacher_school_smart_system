
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

  const ClassState({
    this.status = ClassStatus.initial,
    this.errorMessage,
    this.classes
  });

  ClassState copyWith({
    ClassStatus? status,
    String? errorMessage,
    List<Class>? classes,
  }) {
    return ClassState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      classes: classes ?? this.classes,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, classes];
}