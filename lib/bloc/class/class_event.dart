import 'package:equatable/equatable.dart';

import '../../data/model/class.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

class ClassesUpdatedFromSocket extends ClassEvent {
  final List<Class> classes;

  const ClassesUpdatedFromSocket(this.classes);

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


