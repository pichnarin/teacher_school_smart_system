enum SessionType {
  lab('Lab Session'),
  lecture('Lecture Session'),
  exam('Exam Session');

  final String name;
  const SessionType(this.name);
  @override
  String toString() => name;

  static SessionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'lab':
        return SessionType.lab;
      case 'lecture':
        return SessionType.lecture;
      case 'exam':
        return SessionType.exam;
      default:
        throw ArgumentError('Invalid session type: $value');
    }
  }
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

  @override
  String toString() {
    return 'Session(sessionId: $sessionId, sessionType: $sessionType)';
  }
}