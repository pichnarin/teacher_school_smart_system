import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginMethodChanged extends LoginEvent {
  final LoginMethod method;

  const LoginMethodChanged(this.method);

  @override
  List<Object?> get props => [method];
}

class SendVerificationCodePressed extends LoginEvent {
  final String input;
  final LoginMethod method;

  const SendVerificationCodePressed({required this.input, required this.method});

  @override
  List<Object?> get props => [input, method];
}

class VerifyCodePressed extends LoginEvent {
  final String code;

  const VerifyCodePressed(this.code);

  @override
  List<Object?> get props => [code];
}

class ResendCodePressed extends LoginEvent {}

class GoBackPressed extends LoginEvent {}

enum LoginMethod { email, phone }