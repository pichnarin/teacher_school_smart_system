import 'package:equatable/equatable.dart';

import '../../data/model/class.dart';

enum ClassStatus { initial, loading, success, failure }

class ClassState extends Equatable {
  final ClassStatus status;
  final List<Class>? classes;
  final String? errorMessage;

  const ClassState({
    this.status = ClassStatus.initial,
    this.classes,
    this.errorMessage,
  });

  ClassState copyWith({
    ClassStatus? status,
    List<Class>? classes,
    String? errorMessage,
  }) {
    return ClassState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, classes, errorMessage];
}