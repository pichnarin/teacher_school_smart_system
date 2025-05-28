import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginMethodChanged>(_onLoginMethodChanged);
    on<SendVerificationCodePressed>(_onSendVerificationCodePressed);
    on<VerifyCodePressed>(_onVerifyCodePressed);
    on<ResendCodePressed>(_onResendCodePressed);
    on<GoBackPressed>(_onGoBackPressed);
  }

  void _onLoginMethodChanged(
      LoginMethodChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(loginMethod: event.method));
  }

  void _onSendVerificationCodePressed(
      SendVerificationCodePressed event, Emitter<LoginState> emit) {
    // Validate input
    if (event.method == LoginMethod.email) {
      final emailRegex = RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(event.input)) {
        emit(state.copyWith(error: 'Please enter a valid email address'));
        return;
      }
      emit(state.copyWith(
        email: event.input,
        isVerificationStep: true,
        error: null,
      ));
    } else {
      if (event.input.isEmpty || event.input.length < 10) {
        emit(state.copyWith(error: 'Please enter a valid phone number'));
        return;
      }
      emit(state.copyWith(
        phone: event.input,
        isVerificationStep: true,
        error: null,
      ));
    }

    // TODO: Add API call to send verification code
  }

  void _onVerifyCodePressed(
      VerifyCodePressed event, Emitter<LoginState> emit) {
    // Validate code
    if (event.code.length != 6 || int.tryParse(event.code) == null) {
      emit(state.copyWith(error: 'Please enter all 6 digits'));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    // TODO: Add API call to verify code

    // Navigate will be handled in UI
  }

  void _onResendCodePressed(
      ResendCodePressed event, Emitter<LoginState> emit) {
    // TODO: Add API call to resend code
  }

  void _onGoBackPressed(GoBackPressed event, Emitter<LoginState> emit) {
    emit(state.copyWith(isVerificationStep: false));
  }
}