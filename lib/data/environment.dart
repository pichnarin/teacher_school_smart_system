class Environment {
  static const String endpointBase = "http://localhost:3000/";
  static const String endpointApi = "http://localhost:3000/api";

  // Auth endpoints
  static String get loginEndpoint => "$endpointApi/v1/user/login";
  static String get verifyOtpEndpoint => "$endpointApi/v1/user/verify";
  static String get refreshTokenEndpoint => "$endpointApi/v1/user/refresh-token";
  static String get logoutEndpoint => "$endpointApi/v1/user/auth/logout";
}

// http://localhost:3000/api/v1/user/login
// http://localhost:3000/api/v1/user/verify
// http://localhost:3000/api/v1/user/refresh-token
// http://localhost:3000/api/v1/user/auth/logout

final environment = Environment();

void main(){
  print("Base Endpoint: ${Environment.endpointBase}");
  print("API Endpoint: ${Environment.endpointApi}");
  print("Login Endpoint: ${Environment.loginEndpoint}");
  print("Verify OTP Endpoint: ${Environment.verifyOtpEndpoint}");
  print("Refresh Token Endpoint: ${Environment.refreshTokenEndpoint}");
  print("Logout Endpoint: ${Environment.logoutEndpoint}");
}