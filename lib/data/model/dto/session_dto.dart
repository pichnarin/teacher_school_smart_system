import 'package:pat_asl_portal/data/model/session.dart';

class SessionDTO {
  final String sessionId;
  final SessionType sessionType;

  const SessionDTO({
    required this.sessionId,
    required this.sessionType,
  });

  factory SessionDTO.fromJson(Map<String, dynamic> json) {
    return SessionDTO(
      sessionId: json['id'] ?? '',
      sessionType: json['session_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionType': sessionType,
    };
  }

  Session toSession() {
    return Session(
      sessionId: sessionId,
      sessionType: sessionType,
    );
  }

  static SessionDTO fromSession(Session session) {
    return SessionDTO(
      sessionId: session.sessionId,
      sessionType: session.sessionType,
    );
  }


}