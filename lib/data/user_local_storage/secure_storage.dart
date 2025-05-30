import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStorage {
  static const secureStorage = FlutterSecureStorage();

  Future<void> persistentToken(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
  }

  Future<String?> retrieveToken() async {
    return await secureStorage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await secureStorage.delete(key: 'jwt_token');
  }

  // // Save user profile to secure storage
  // Future<void> saveUserProfile(String name, String email, {String? avatar}) async {
  //   final Map<String, String> profile = {
  //     'name': name,
  //     'email': email,
  //     if (avatar != null) 'avatar': avatar,
  //   };
  //   await secureStorage.write(key: 'user_profile', value: jsonEncode(profile));
  // }
  //
  // // Retrieve user profile from secure storage
  // Future<Map<String, String>?> getUserProfile() async {
  //   final String? profileData = await secureStorage.read(key: 'user_profile');
  //
  //   if (profileData != null) {
  //     final Map<String, dynamic> profileMap = jsonDecode(profileData);
  //     return profileMap.map((key, value) => MapEntry(key, value.toString()));
  //   }
  //
  //   return null; // No user profile found
  // }
  //
  // // Delete the user profile from secure storage (e.g., for logout)
  // Future<void> deleteUserProfile() async {
  //   await secureStorage.delete(key: 'user_profile');
  // }
}

final secureLocalStorage = SecureLocalStorage();