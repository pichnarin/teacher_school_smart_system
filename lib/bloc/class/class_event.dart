abstract class ClassEvent{
  const ClassEvent();

  @override
  List<Object?> get props => [];
}

class FetchClass extends ClassEvent {
  final String? roomId;
  final String? scheduleId;
  final String? teacherId;


  const FetchClass({this.roomId, this.scheduleId, this.teacherId});

  @override
  List<Object?> get props => [roomId, scheduleId, teacherId];
}

class FetchTodayClasses extends ClassEvent {
  final String? roomId;
  final String? scheduleId;
  final String? teacherId;

  const FetchTodayClasses({this.roomId, this.scheduleId, this.teacherId});

  @override
  List<Object?> get props => [roomId, scheduleId, teacherId];
}

class FetchNextClasses extends ClassEvent {
  final String? roomId;
  final String? scheduleId;
  final String? teacherId;

  const FetchNextClasses({this.roomId, this.scheduleId, this.teacherId});

  @override
  List<Object?> get props => [roomId, scheduleId, teacherId];
}