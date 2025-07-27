import 'package:equatable/equatable.dart';

abstract class ClassSessionEvent extends Equatable {
  const ClassSessionEvent();

  @override
  List<Object?> get props => [];
}

class FetchClassSessions extends ClassSessionEvent {
  final String? roomId;
  final String? scheduleId;
  final String? teacherId;


  const FetchClassSessions({this.roomId, this.scheduleId, this.teacherId});

  @override
  List<Object?> get props => [roomId, scheduleId, teacherId];
}

class FetchClassSessionsByDate extends ClassSessionEvent {
  final String date;

  const FetchClassSessionsByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class FetchClassSessionById extends ClassSessionEvent {
  final String classId;

  const FetchClassSessionById(this.classId);

  @override
  List<Object?> get props => [classId];
}


