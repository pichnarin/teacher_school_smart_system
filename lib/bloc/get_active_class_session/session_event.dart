
import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class FetchActiveSession extends SessionEvent {
  final String classId;
  final String sessionDate;
  final String startTime;
  final String endTime;

  const FetchActiveSession(this.classId, this.sessionDate, this.startTime, this.endTime);

  @override
  List<Object> get props => [classId];
}
