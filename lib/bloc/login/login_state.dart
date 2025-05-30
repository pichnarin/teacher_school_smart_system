import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isOTPRequired;
  final String? errorMessage;
  final String? email;

  const LoginState({
    this.isLoading = false,
    this.isOTPRequired = false,
    this.errorMessage,
    this.email,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isOTPRequired,
    String? errorMessage,
    String? email,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isOTPRequired: isOTPRequired ?? this.isOTPRequired,
      errorMessage: errorMessage,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [isLoading, isOTPRequired, errorMessage, email];
}
