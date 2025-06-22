enum SessionType {
  morning('Morning Session'),
  afternoon('Afternoon Session'),
  evening('Evening Session');

  final String name;
  const SessionType(this.name);
  @override
  String toString() => name;

  static SessionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'morning':
        return SessionType.morning;
      case 'afternoon':
        return SessionType.afternoon;
      case 'evening':
        return SessionType.evening;
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