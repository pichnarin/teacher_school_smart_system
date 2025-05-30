import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? token;
  final DateTime? tokenExpiry;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.token,
    this.tokenExpiry,
  });

  bool get isAuthenticated {
    if (token == null || tokenExpiry == null) return false;
    return tokenExpiry!.isAfter(DateTime.now());
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    String? token,
    DateTime? tokenExpiry,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'],
      tokenExpiry: json['tokenExpiry'] != null
          ? DateTime.parse(json['tokenExpiry'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'token': token,
      if (tokenExpiry != null) 'tokenExpiry': tokenExpiry!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, username, email, role, token, tokenExpiry];
}