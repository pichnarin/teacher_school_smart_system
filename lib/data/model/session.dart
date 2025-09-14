enum SessionType {
  normal('វគ្គបង្រៀន'),
  exam('វគ្គប្រឡង');

  final String name;
  const SessionType(this.name);
  @override
  String toString() => name;

  static SessionType fromString(String type) {
    return SessionType.values.firstWhere(
          (e) => e.name == type.toLowerCase(),
      orElse: () => SessionType.normal,
    );
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