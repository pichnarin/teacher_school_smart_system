import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<OTPSubmitted>(_onOTPSubmitted);
    on<ResendOTP>(_onResendOTP);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    // Validate
    if (event.input.isEmpty || event.password.length < 6) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email/username or password',
      ));
      return;
    }

    // Simulate successful login, OTP required
    emit(state.copyWith(
      isLoading: false,
      isOTPRequired: true,
      email: event.input,
    ));
  }

  void _onOTPSubmitted(OTPSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    if (event.code != '123456') {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid OTP code',
      ));
    } else {
      emit(state.copyWith(isLoading: false));
      // Navigate to home (UI will handle this)
    }
  }

  void _onResendOTP(ResendOTP event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1)); // Simulate resend

    emit(state.copyWith(isLoading: false));
  }
}
