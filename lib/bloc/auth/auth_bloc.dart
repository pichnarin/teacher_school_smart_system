import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/service/auth/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginInitiated>(_onLoginInitiated);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
    on<ResendOTPRequested>(_onResendOTPRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await _authService.getCurrentUser();

      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'សម័យបានផុតកំណត់។ សូមចូលម្តងទៀត។',
          clearUser: true,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'ការត្រួតពិនិត្យការផ្ទៀងផ្ទាត់ត្រូវបានបរាជ័យ: ${e.toString()}',
        clearUser: true,
        isLoading: false,
      ));
    }
  }

  void _onLoginInitiated(
      LoginInitiated event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final result = await _authService.initiateLogin(
        event.username,
        event.password,
      );

      emit(state.copyWith(
        status: AuthStatus.awaitingOtp,
        pendingUsername: event.username,
        pendingEmail: result['email'],
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onOTPVerificationRequested(
      OTPVerificationRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final user = await _authService.verifyOTP(event.username, event.otp);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        pendingUsername: null,
        pendingEmail: null,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.awaitingOtp,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onResendOTPRequested(
      ResendOTPRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final result = await _authService.initiateLogin(event.username, event.password);

      // Only emit successMessage if resend succeeded
      if (result != null) {
        emit(state.copyWith(
          status: AuthStatus.awaitingOtp, // keep user in OTP step
          successMessage: 'OTP បានផ្ញើម្តងទៀតដោយជោគជ័យ។ សូមពិនិត្យអ៊ីមែលរបស់អ្នក។',
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.awaitingOtp,
          errorMessage: 'បរាជ័យក្នុងការផ្ញើ OTP ម្តងទៀត។ សូមព្យាយាមម្តងទៀត។',
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.awaitingOtp,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }


  void _onTokenRefreshRequested(
      TokenRefreshRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await _authService.refreshToken();

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'សម័យបានផុតកំណត់។ សូមចូលម្តងទៀត។',
        clearUser: true,
        isLoading: false,
      ));
    }
  }

  void _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authService.logout();
    } finally {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
        isLoading: false,
      ));
    }
  }
}
