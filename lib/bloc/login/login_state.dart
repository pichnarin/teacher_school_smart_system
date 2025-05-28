import 'package:equatable/equatable.dart';
import 'login_event.dart';

class LoginState extends Equatable {
  final LoginMethod loginMethod;
  final bool isVerificationStep;
  final String? email;
  final String? phone;
  final bool isLoading;
  final String? error;

  const LoginState({
    this.loginMethod = LoginMethod.email,
    this.isVerificationStep = false,
    this.email,
    this.phone,
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    LoginMethod? loginMethod,
    bool? isVerificationStep,
    String? email,
    String? phone,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      loginMethod: loginMethod ?? this.loginMethod,
      isVerificationStep: isVerificationStep ?? this.isVerificationStep,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    loginMethod,
    isVerificationStep,
    email,
    phone,
    isLoading,
    error,
  ];
}