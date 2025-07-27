import 'package:equatable/equatable.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

class FetchClasses extends ClassEvent {
  final String? teacherId;


  const FetchClasses({this.teacherId});

  @override
  List<Object?> get props => [teacherId];
}

class FetchClassByDate extends ClassEvent {
  final String date;

  const FetchClassByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class FetchClassById extends ClassEvent {
  final String classId;

  const FetchClassById(this.classId);

  @override
  List<Object?> get props => [classId];
}

class FetchStudentReport extends ClassEvent {
  final String classId;
  final String reportMonth;
  final String reportYear;

  const FetchStudentReport({
    required this.classId,
    required this.reportMonth,
    required this.reportYear,
  });

  @override
  List<Object?> get props => [classId, reportMonth, reportYear];
}

