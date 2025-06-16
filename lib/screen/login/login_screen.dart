import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pat_asl_portal/screen/login/widget/password_field_box.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/auth/auth_event.dart';
import '../navigator/navigator_controller.dart';
import '../navigator/navigator_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
        (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
  String _lastUsername = '';
  String _lastPassword = '';

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            if (state.isAuthenticated) {
              //set the selected index to homescreen
              final navigatorController = Get.find<NavigatorController>();
              navigatorController.selectedIndex.value = 0;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NavigatorMenu()),
              );
            }

            // Save credentials for potential OTP resend
            if (state.isAwaitingOtp && _lastUsername.isEmpty) {
              _lastUsername = usernameController.text;
              _lastPassword = passwordController.text;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state.isAwaitingOtp
                    ? _buildOTPForm(context, state)
                    : _buildLoginForm(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      key: const ValueKey('login_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Image.asset(
          'assets/images/education_logo.png',
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.school, size: 80);
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Email or Username',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        /*
        Password field with visibility toggle
         */

        PasswordFieldBox(controller: passwordController),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: state.isLoading
              ? null
              : () {
            context.read<AuthBloc>().add(
              LoginInitiated(
                usernameController.text,
                passwordController.text,
              ),
            );
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: colorScheme.primary.withOpacity(0.3),
          ),
          child: state.isLoading
              ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.onPrimary,
            ),
          )
              : const Text('Login'),
        ),
      ],
    );
  }

  Widget _buildOTPForm(BuildContext context, AuthState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      key: const ValueKey('otp_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Image.asset(
          'assets/images/education_logo.png',
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.school, size: 80);
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Verification',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Enter the 6-digit OTP code sent to',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        Text(
          state.pendingEmail ?? "your email",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              height: 60,
              child: TextField(
                controller: otpControllers[index],
                focusNode: otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    otpFocusNodes[index + 1].requestFocus();
                  }
                  // Auto-submit when all digits are entered
                  if (index == 5 && value.isNotEmpty) {
                    final code = otpControllers.map((c) => c.text).join();
                    if (code.length == 6) {
                      context.read<AuthBloc>().add(
                        OTPVerificationRequested(
                          state.pendingUsername ?? '',
                          code,
                        ),
                      );
                    }
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: state.isLoading
              ? null
              : () {
            final code = otpControllers.map((c) => c.text).join();
            context.read<AuthBloc>().add(
              OTPVerificationRequested(
                state.pendingUsername ?? '',
                code,
              ),
            );
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: colorScheme.primary.withOpacity(0.3),
          ),
          child: state.isLoading
              ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.onPrimary,
            ),
          )
              : const Text('Verify'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: state.isLoading
              ? null
              : () {
            context.read<AuthBloc>().add(
              ResendOTPRequested(
                state.pendingUsername ?? _lastUsername,
                _lastPassword,
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Resend OTP'),
            ],
          ),
        ),
      ],
    );
  }
}