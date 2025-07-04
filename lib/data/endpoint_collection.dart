// class Environment {
//   static const String endpointBase = "http://localhost:3000/";
//   static const String endpointApi = "http://localhost:3000/api";
//
//   // Auth endpoints
//   static String get loginEndpoint => "$endpointApi/v1/user/login";
//   static String get verifyOtpEndpoint => "$endpointApi/v1/user/verify";
//   static String get refreshTokenEndpoint => "$endpointApi/v1/user/refresh-token";
//   static String get logoutEndpoint => "$endpointApi/v1/user/auth/logout";
// }

// http://localhost:3000/api/v1/user/login
// http://localhost:3000/api/v1/user/verify
// http://localhost:3000/api/v1/user/refresh-token
// http://localhost:3000/api/v1/user/auth/logout


import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class EndpointCollection {
  static const String _devServerIp = "192.168.1.6";
  static const String _socketServerUrl = "http://192.168.1.6:3000";

  static String get endpointBase {
    if (kIsWeb) {
      return "http://localhost:3000/";
    } else if (Platform.isAndroid) {
      bool isEmulator = false;
      return isEmulator ? "http://10.0.2.2:3000/" : "http://$_devServerIp:3000/";
    } else {
      // iOS simulator uses localhost, physical devices need actual IP
      return Platform.isIOS ? "http://localhost:3000/" : "http://$_devServerIp:3000/";
    }
  }

  static String get socketServerUrl => _socketServerUrl;

  static String get endpointApi => "${endpointBase}api";

  static String get loginEndpoint => "$endpointApi/v1/user/login";
  static String get verifyOtpEndpoint => "$endpointApi/v1/user/verify";
  static String get refreshTokenEndpoint => "$endpointApi/v1/user/refresh-token";
  static String get logoutEndpoint => "$endpointApi/v1/user/auth/logout";


 static String get classEndpoint => '$endpointApi/v1/user/auth/teacher/classes';

 static String get enrollmentEndpoint => '$endpointApi/v1/user/auth/teacher/enrollment';

  static String get allClassesEndpoint => '$classEndpoint/all';

  static String Function(String classId) get classByIdEndpoint => (String classId) => '$classEndpoint/by-id?id=$classId';
  static String Function(String date) get classByDateEndpoint=> (String date) => '$classEndpoint/by-date?date=$date';
  static String Function(String roomName) get classByRoomEndpoint => (String roomName) => '$classEndpoint/by-room-name?room_name=$roomName';
  static String Function(String grade) get classByGradeEndpoint => (String grade) => '$classEndpoint/by-grade?grade=$grade';

  static String Function(String classId) get studentListEndpoint => (String classId) => '$enrollmentEndpoint/student_list/by-class_id?class_id=$classId';

  static String get markAttendanceEndpoint => '$enrollmentEndpoint/attendance';
  static String Function(String attendanceId) get patchAttendanceEndpoint => (String attendanceId) => '$enrollmentEndpoint/attendance/$attendanceId';
  static String Function(String classId, String date) get getAttendanceByClass =>
          (String classId, String date) =>
      '$enrollmentEndpoint/attendance/by-class_id?class_id=$classId&date=$date';

}

final environment = EndpointCollection();


// teacherRouter.post('/enrollment/attendance', (req, res, next) => erollmentService.markAttendance(req, res, next));
// teacherRouter.patch('/enrollment/attendance/:attendance_id', (req, res, next) =>erollmentService.patchAttendance(req, res, next));
