class Environment {
  static const String endpointBase = "http://192.168.1.13:8000";
  static const String endpointApi = "http://192.168.1.13:8000/api";

  // Auth endpoints
  static String get loginEndpoint => "$endpointApi/auth/login";
  static String get verifyOtpEndpoint => "$endpointApi/auth/verify";
  static String get refreshTokenEndpoint => "$endpointApi/auth/refresh-token";
  static String get logoutEndpoint => "$endpointApi/auth/logout";
}

final environment = Environment();