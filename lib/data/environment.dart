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

class Environment {
  // For development, you can change this to your actual server
  static const String _devServerIp = "192.168.1.6"; // Replace with your PC's IP

  static String get endpointBase {
    if (kIsWeb) {
      return "http://localhost:3000/";
    } else if (Platform.isAndroid) {
      bool isEmulator = false; // Set this based on detection or build config
      return isEmulator ? "http://10.0.2.2:3000/" : "http://$_devServerIp:3000/";
    } else {
      // iOS simulator uses localhost, physical devices need actual IP
      return Platform.isIOS ? "http://localhost:3000/" : "http://$_devServerIp:3000/";
    }
  }

  static String get endpointApi => "${endpointBase}api";

  // Auth endpoints
  static String get loginEndpoint => "$endpointApi/v1/user/login";
  static String get verifyOtpEndpoint => "$endpointApi/v1/user/verify";
  static String get refreshTokenEndpoint => "$endpointApi/v1/user/refresh-token";
  static String get logoutEndpoint => "$endpointApi/v1/user/auth/logout";

  // Class endpoints

}

final environment = Environment();

void main(){
  print("Base Endpoint: ${Environment.endpointBase}");
  print("API Endpoint: ${Environment.endpointApi}");
  print("Login Endpoint: ${Environment.loginEndpoint}");
  print("Verify OTP Endpoint: ${Environment.verifyOtpEndpoint}");
  print("Refresh Token Endpoint: ${Environment.refreshTokenEndpoint}");
  print("Logout Endpoint: ${Environment.logoutEndpoint}");
}