import 'package:pat_asl_portal/data/model/session.dart';

class SessionDTO {
  final String sessionId;
  final SessionType sessionType;

  const SessionDTO({
    required this.sessionId,
    required this.sessionType,
  });

  factory SessionDTO.fromJson(Map<String, dynamic> json) {
    try{
      return SessionDTO(
        sessionId: json['id'] ?? '',
        sessionType: SessionType.fromString(json['session_type'] ?? ''),
      );
    }catch (e) {

      rethrow;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'id': sessionId, // match this key with fromJson if you're using 'id'
      'session_type': sessionType.name, // or sessionType.toString().split('.').last
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