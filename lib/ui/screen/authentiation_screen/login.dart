import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/util/theme/app_color.dart';

import '../../../util/controller/login_controller.dart';
import '../../../util/formatter/phone_number_formatter.dart';
import '../../widget/global/navigator_menu.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() => controller.isVerificationStep.value
              ? _buildVerificationStep(controller)
              : _buildInitialStep(controller)),
        ),
      ),
    );
  }

  Widget _buildInitialStep(LoginController controller) {
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
            errorBuilder: (context, error, stackTrace) => const Icon(
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
          selected: {controller.loginMethod.value},
          onSelectionChanged: (Set<LoginMethod> selection) {
            controller.loginMethod.value = selection.first;
          },
        ),
        const SizedBox(height: 32),

        // Dynamic input field (email or phone)
        Obx(() => controller.loginMethod.value == LoginMethod.email
            ? TextField(
          controller: controller.emailController,
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
          controller: controller.phoneController,
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
        ),
        const SizedBox(height: 32),

        // Continue button
        ElevatedButton(
          onPressed: controller.sendVerificationCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Continue', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildVerificationStep(LoginController controller) {
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
        Obx(() => Text(
          controller.loginMethod.value == LoginMethod.email
              ? 'Enter the code sent to your email ${controller.emailController.text}'
              : 'Enter the code sent to your phone ${controller.phoneController.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        )),
        const SizedBox(height: 40),

        // Verification code input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
                (index) => SizedBox(
              width: 50,
              child: TextField(
                controller: controller.codeControllers[index],
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
                    FocusScope.of(Get.context!).nextFocus();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Verify button
        ElevatedButton(
          onPressed: controller.verifyCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Verify', style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 16),

        // Resend code button
        TextButton(
          onPressed: controller.resendCode,
          child: const Text('Resend Code'),
        ),

        // Back button
        TextButton(
          onPressed: controller.goBack,
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}

