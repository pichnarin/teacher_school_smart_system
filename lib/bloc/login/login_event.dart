import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String input; // email or username
  final String password;

  const LoginSubmitted(this.input, this.password);

  @override
  List<Object?> get props => [input, password];
}

class OTPSubmitted extends LoginEvent {
  final String code;

  const OTPSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

class ResendOTP extends LoginEvent {}
