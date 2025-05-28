import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/login/login_bloc.dart';
import 'package:pat_asl_portal/bloc/login/login_event.dart';
import 'package:pat_asl_portal/bloc/login/login_state.dart';
import 'package:pat_asl_portal/util/theme/app_color.dart';
import 'package:pat_asl_portal/util/formatter/phone_number_formatter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    for (var controller in codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                }
              },
              builder: (context, state) {
                return state.isVerificationStep
                    ? _buildVerificationStep(context, state)
                    : _buildInitialStep(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialStep(BuildContext context, LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo or header image
        const SizedBox(height: 40),
        Center(
          child: Image.asset(
            'assets/images/logo.png', // Replace with your logo
            height: 100,
            width: 100,
            errorBuilder:
                (context, error, stackTrace) => const Icon(
                  Icons.school,
                  size: 100,
                  color: AppColor.primary,
                ),
          ),
        ),
        const SizedBox(height: 40),

        // Login method selector
        SegmentedButton<LoginMethod>(
          segments: const [
            ButtonSegment(
              value: LoginMethod.email,
              label: Text('Email'),
              icon: Icon(Icons.email),
            ),
            ButtonSegment(
              value: LoginMethod.phone,
              label: Text('Phone'),
              icon: Icon(Icons.phone),
            ),
          ],
          selected: {state.loginMethod},
          onSelectionChanged: (Set<LoginMethod> selection) {
            context.read<LoginBloc>().add(LoginMethodChanged(selection.first));
          },
        ),
        const SizedBox(height: 32),

        // Dynamic input field (email or phone)
        state.loginMethod == LoginMethod.email
            ? TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'example@mail.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.secondary),
                ),
              ),
            )
            : TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneNumberFormatter(),
              ],
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '855 17963338',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.secondary),
                ),
              ),
            ),
        const SizedBox(height: 32),

        // Continue button
        ElevatedButton(
          onPressed: () {
            final input =
                state.loginMethod == LoginMethod.email
                    ? emailController.text
                    : phoneController.text;

            context.read<LoginBloc>().add(
              SendVerificationCodePressed(
                input: input,
                method: state.loginMethod,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Continue', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildVerificationStep(BuildContext context, LoginState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        // Header text
        Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // Subtitle with contact method
        Text(
          state.loginMethod == LoginMethod.email
              ? 'Enter the code sent to your email ${state.email}'
              : 'Enter the code sent to your phone ${state.phone}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 40),

        // Verification code input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 50,
              child: TextField(
                controller: codeControllers[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Verify button
        ElevatedButton(
          onPressed: () {
            // Combine all verification code digits
            final code = codeControllers.map((c) => c.text).join();
            context.read<LoginBloc>().add(VerifyCodePressed(code));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),

        // Resend code button
        TextButton(
          onPressed: () {
            context.read<LoginBloc>().add(ResendCodePressed());
          },
          child: const Text('Resend Code'),
        ),

        // Back button
        TextButton(
          onPressed: () {
            context.read<LoginBloc>().add(GoBackPressed());
          },
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}
