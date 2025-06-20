import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/user.dart';
import '../repository/auth_repository.dart';
import '../user_local_storage/secure_storage.dart';

class AuthService {
  final AuthRepository _repository;
  final SecureLocalStorage _storage;

  AuthService({
    required AuthRepository repository,
    required SecureLocalStorage storage,
  })  : _repository = repository,
        _storage = storage;

  Future<Map<String, dynamic>> initiateLogin(String username, String password) async {
    final result = await _repository.initiateLogin(username, password);
    return result;
  }

  Future<User> verifyOTP(String username, String otp) async {
    final result = await _repository.verifyOTP(username, otp);

    final user = User.fromJson(result['user']);
    final token = result['token'];

    if (token != null) {
      await _storage.persistentToken(token);
      final tokenExpiry = JwtDecoder.getExpirationDate(token);
      return user.copyWith(token: token, tokenExpiry: tokenExpiry);
    }
    return user;
  }

  Future<User> refreshToken() async {
    final currentToken = await _storage.retrieveToken();
    if (currentToken == null) throw Exception('No token available');

    final result = await _repository.refreshToken(currentToken);
    final user = User.fromJson(result['user']);
    final newToken = result['token'];

    if (newToken != null) {
      await _storage.persistentToken(newToken);
      final tokenExpiry = JwtDecoder.getExpirationDate(newToken);
      return user.copyWith(token: newToken, tokenExpiry: tokenExpiry);
    }
    return user;
  }

  Future<void> logout() async {
    try {
      final currentToken = await _storage.retrieveToken();
      if (currentToken != null) {
        await _repository.logout(currentToken);
      }
    } finally {
      await _storage.deleteToken();
    }
  }


  Future<User?> getCurrentUser() async {
    final token = await _storage.retrieveToken();

    if (token == null) {
      print('[AuthService] No token found.');
      return null;
    }

    try {
      //  Decode and print token expiry
      final expiryDate = JwtDecoder.getExpirationDate(token);
      final isExpired = JwtDecoder.isExpired(token);

      print('[AuthService] Token found: $token');
      print('[AuthService] Token expires at: $expiryDate');
      print('[AuthService] Token expired: $isExpired');

      // Continue with your refresh logic
      return await refreshToken();
    } catch (e) {
      print('[AuthService] Failed to refresh token: $e');
      await _storage.deleteToken();
      throw Exception('Session expired');
    }
  }

}