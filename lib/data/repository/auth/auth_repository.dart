import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../util/exception/api_exception.dart';
import '../../endpoint_collection.dart';

class AuthRepository {
  final http.Client _httpClient;

  AuthRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> initiateLogin(String username, String password) async {
    final response = await _httpClient.post(
      Uri.parse(EndpointCollection.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw ApiException(
        data['message'] ?? 'Login failed',
        response.statusCode,
      );
    }

    return data['data'];
  }

  Future<Map<String, dynamic>> verifyOTP(String username, String otp) async {
    final response = await _httpClient.post(
      Uri.parse(EndpointCollection.verifyOtpEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'otp': otp}),
    );

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw ApiException(
        data['message'] ?? 'OTP verification failed',
        response.statusCode,
      );
    }

    return data['data'];
  }

  Future<Map<String, dynamic>> refreshToken(String token) async {
    final response = await _httpClient.post(
      Uri.parse(EndpointCollection.refreshTokenEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    final data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw ApiException(
        data['message'] ?? 'Token refresh failed',
        response.statusCode,
      );
    }

    return data['data'];
  }

  Future<void> logout(String token) async {
    await _httpClient.post(
      Uri.parse(EndpointCollection.logoutEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}