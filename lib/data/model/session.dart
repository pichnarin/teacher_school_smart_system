enum SessionType {
  morning,
  afternoon,
  evening,
}

class Session{
  final String sessionId;
  final SessionType sessionType;

  Session({
    required this.sessionId,
    required this.sessionType,
  });

  String get getSessionId => sessionId;
  String get getSessionType => sessionType.toString().split('.').last;
}