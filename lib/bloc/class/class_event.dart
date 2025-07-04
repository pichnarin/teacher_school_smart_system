import 'package:equatable/equatable.dart';

import '../../data/model/class.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

class UpdateClassesFromWebSocket extends ClassEvent {
  final List<Class> classes;

  const UpdateClassesFromWebSocket(this.classes);

  @override
  List<Object?> get props => [classes];
}

class FetchClasses extends ClassEvent {
  final String? roomId;
  final String? scheduleId;
  final String? teacherId;


  const FetchClasses({this.roomId, this.scheduleId, this.teacherId});

  @override
  List<Object?> get props => [roomId, scheduleId, teacherId];
}

class FetchClassesByDate extends ClassEvent {
  final String date;

  const FetchClassesByDate(this.date);

  @override
  List<Object?> get props => [date];
}

class FetchClassById extends ClassEvent {
  final String classId;

  const FetchClassById(this.classId);

  @override
  List<Object?> get props => [classId];
}




