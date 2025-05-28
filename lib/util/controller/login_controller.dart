import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../ui/widget/global/navigator_menu.dart';

enum LoginMethod { email, phone }

class LoginController extends GetxController {
  final loginMethod = LoginMethod.email.obs;
  final isVerificationStep = false.obs;

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final List<TextEditingController> codeControllers =
  List.generate(6, (_) => TextEditingController());

  void sendVerificationCode() {
    // Validate input
    if (loginMethod.value == LoginMethod.email) {
      if (!GetUtils.isEmail(emailController.text)) {
        Get.snackbar('Invalid Email', 'Please enter a valid email address');
        return;
      }
    } else {
      if (phoneController.text.isEmpty || phoneController.text.length < 10) {
        Get.snackbar('Invalid Phone', 'Please enter a valid phone number');
        return;
      }
    }

    // TODO: Add API call to send verification code

    isVerificationStep.value = true;
  }

  void verifyCode() {
    // Collect the verification code
    final code = codeControllers.map((c) => c.text).join();

    // Validate code
    if (code.length != 6 || !GetUtils.isNumericOnly(code)) {
      Get.snackbar('Invalid Code', 'Please enter all 6 digits');
      return;
    }

    // TODO: Add API call to verify code

    // Navigate to main app
    Get.offAll(() => const NavigatorMenu());
  }

  void resendCode() {
    // Clear existing code fields
    for (var controller in codeControllers) {
      controller.clear();
    }

    // TODO: Add API call to resend code
    Get.snackbar('Code Sent', 'A new verification code has been sent');
  }

  void goBack() {
    isVerificationStep.value = false;
    // Clear code fields
    for (var controller in codeControllers) {
      controller.clear();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    for (var controller in codeControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}