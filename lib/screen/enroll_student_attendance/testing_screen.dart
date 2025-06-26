import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/testing_screen_two.dart';
import '../global_widget/base_screen.dart';
import '../navigator/navigator_controller.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.find<NavigatorController>().pushToCurrentTab(TestingScreen2());
          },
          child: Text("Go to TestingScreen"),
        ),
      ),
    );
  }
}