import 'package:equatable/equatable.dart';
import '../../data/model/user.dart';

enum AuthStatus {
  initial,
  loading,
  unauthenticated,
  awaitingOtp,
  authenticated,
  failure
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? pendingUsername;
  final String? pendingEmail;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.pendingUsername,
    this.pendingEmail,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? pendingUsername,
    String? pendingEmail,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingUsername: pendingUsername ?? this.pendingUsername,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAwaitingOtp => status == AuthStatus.awaitingOtp;

  @override
  List<Object?> get props => [status, user, errorMessage, pendingUsername, pendingEmail, isLoading];
}