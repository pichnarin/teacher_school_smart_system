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
    }catch (e, stack) {
      print('❌ Failed to parse ScheduleDTO: $e');
      print('🔍 Stack trace:\n$stack');
      print('🧪 Data:\n$json');
      rethrow;
    }
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