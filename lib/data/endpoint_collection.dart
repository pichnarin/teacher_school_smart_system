import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class EndpointCollection {
  static const String _devServerIp = "192.168.1.8";
  static const String _socketServerUrl = "http://192.168.1.8:3000";

  static String get endpointBase {
    if (kIsWeb) {
      return "http://localhost:3000/";
    } else if (Platform.isAndroid) {
      bool isEmulator = false;
      return isEmulator
          ? "http://10.0.2.2:3000/"
          : "http://$_devServerIp:3000/";
    } else {
      // iOS simulator uses localhost, physical devices need actual IP
      return Platform.isIOS
          ? "http://localhost:3000/"
          : "http://$_devServerIp:3000/";
    }
  }

  static String get socketServerUrl => _socketServerUrl;
  static String get endpointApi => "${endpointBase}api";


  // authentication endpoint
  static String get loginEndpoint => "$endpointApi/v1/user/login";
  static String get verifyOtpEndpoint => "$endpointApi/v1/user/verify";
  static String get refreshTokenEndpoint => "$endpointApi/v1/user/refresh-token";
  static String get logoutEndpoint => "$endpointApi/v1/user/auth/logout";


  //classes endpoint
  static String get classesEndpoint => '$endpointApi/v1/user/auth/teacher/classes';
  static String get allClassesEndpoint => '$classesEndpoint/all';
  static String Function(String classId) get classByIdEndpoint => (String classId) => '$classesEndpoint/by-id?id=$classId';
  static String Function(String grade) get classByGradeEndpoint => (String grade) => '$classesEndpoint/by-grade?grade=$grade';
  static String Function(String roomName) get classByRoomEndpoint => (String roomName) => '$classesEndpoint/by-room-name?room_name=$roomName';
  static String Function(String date) get classByDateEndpoint => (String date) => '$classesEndpoint/by-date?date=$date';


  //class session endpoint
  static String get classSessionEndpoint => '$endpointApi/v1/user/auth/teacher/class-session';
  static String get allClassSessionEndpoint => '$classSessionEndpoint/all';
  static String Function(String classId) get classSessionByIdEndpoint => (String classId) => '$classSessionEndpoint/by-id?id=$classId';
  static String Function(String date) get classSessionByDateEndpoint => (String date) => '$classSessionEndpoint/by-date?date=$date';
  static String Function(String roomName) get classSessionByRoomEndpoint => (String roomName) => '$classSessionEndpoint/by-room-name?room_name=$roomName';
  static String Function(String grade) get classSessionByGradeEndpoint => (String grade) => '$classSessionEndpoint/by-grade?grade=$grade';


  //enrollment endpoint
  static String get enrollmentEndpoint => '$endpointApi/v1/user/auth/teacher/enrollment';
  static String Function(String classId) get studentListEndpoint => (String classId) => '$enrollmentEndpoint/student_list/by-class_id?class_id=$classId';
  static String get markAttendanceEndpoint => '$enrollmentEndpoint/attendance';
  static String Function(String attendanceId) get patchAttendanceEndpoint => (String attendanceId) => '$enrollmentEndpoint/attendance/$attendanceId';
  static String Function(String classId, String classSessionId) get getAttendanceByClassSession => (String classId, String classSessionId) => '$enrollmentEndpoint/attendance/by-class_session?class_id=$classId&class_session_id=$classSessionId';
  static String Function(String classId) get setExamScoresEndpoint => (String classId) => '$endpointApi/v1/user/auth/teacher/classes/$classId/exam-scores';
  static String Function(String classId) get getExamScoresEndpoint => (String classId) => '$endpointApi/v1/user/auth/teacher/classes/$classId/exam-scores';
  static String Function(String classId, String examScoreId) get patchExamScoresEndpoint => (String classId, String examScoreId) => '$endpointApi/v1/user/auth/teacher/classes/$classId/exam-scores/$examScoreId';


  //daily evaluation endpoint
  static String get dailyEvaluationEndpoint => '$endpointApi/v1/user/auth/teacher/daily-evaluation';
  static String createDailyEvaluation(String classSessionId) => '$dailyEvaluationEndpoint/create?class_session_id=$classSessionId';

  static Function(String classId, String sessionDate) get getDailyEvaluation => (String classId, String sessionDate) => '$dailyEvaluationEndpoint/by-class-session-date?class_id=$classId&session_date=$sessionDate';
  static Function(String classSessionId) get checkDailyEvaluationEndpoint => (String classSessionId) => '$dailyEvaluationEndpoint/check-exist?class_session_id=$classSessionId';
  static String get patchDailyEvaluationEndpoint => '$dailyEvaluationEndpoint/patch';


  static String get sessionEndpoint => '$endpointApi/v1/user/auth/teacher/class-session';
  static String Function(String classId, String sessionDate, String startTime, String endTime) get activeSessionEndpoint => (String classId, String sessionDate, String startTime, String endTime) => '$sessionEndpoint/active?class_id=$classId&session_date=$sessionDate&start_time=$startTime&end_time=$endTime';
  static String Function(String classSessionId) get patchExamSession => (String classSessionId) => '$sessionEndpoint/$classSessionId/exam-type';
  static String Function(String classId, String subjectId, String examMonth, String examYear) get isExamScoresExisted => (String classId, String subjectId, String examMonth, String examYear) {return '$endpointApi/v1/user/auth/teacher/classes/$classId/exam-scores?subject_id=$subjectId&exam_month=$examMonth&exam_year=$examYear';};

  //student report including exam scores, daily evaluation and attendance base on class and month and year
  static String Function(String classId, int month, int year) get studentReportEndpoint => (String classId, int month, int year) => '$endpointApi/v1/user/auth/teacher/classes/student-report?classId=$classId&month=$month&year=$year';
  static String get generateReportEndpoint => '$endpointApi/v1/user/auth/teacher/classes/generate-student-report';

}


