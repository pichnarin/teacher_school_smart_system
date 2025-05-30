import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginInitiated extends AuthEvent {
  final String username;
  final String password;

  const LoginInitiated(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class OTPVerificationRequested extends AuthEvent {
  final String username;
  final String otp;

  const OTPVerificationRequested(this.username, this.otp);

  @override
  List<Object> get props => [username, otp];
}

class ResendOTPRequested extends AuthEvent {
  final String username;
  final String password;

  const ResendOTPRequested(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class TokenRefreshRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}