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


 static String get classEndpoint => '$endpointApi/v1/user/auth/teacher';
 
  static String get allClassesEndpoint => '$classEndpoint/classes/all';
  static String Function(String classId) get classByIdEndpoint => (String classId) => '$classEndpoint/classes/$classId';
  static String Function(String grade) get classByGradeEndpoint => (String grade) => '$classEndpoint/classes/grade/$grade';
  static String Function(String teacherId) get classByTeacherEndpoint => (String teacherId) => '$classEndpoint/teacher/$teacherId/classes';

}

final environment = EndpointCollection();

