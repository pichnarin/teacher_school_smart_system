import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/testing_screen.dart';
import '../global_widget/base_screen.dart';
import '../navigator/navigator_controller.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.find<NavigatorController>().pushToCurrentTab(TestingScreen());
          },
          child: Text("Go to TestingScreen"),
        ),
      ),
    );
  }
}
