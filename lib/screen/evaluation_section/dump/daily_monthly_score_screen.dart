import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';

import '../../navigator/navigator_controller.dart';

class DailyMonthlyScoreScreen extends StatefulWidget {
  final String classId;
  const DailyMonthlyScoreScreen({super.key, required this.classId});

  @override
  State<DailyMonthlyScoreScreen> createState() =>
      _DailyMonthlyScoreScreenState();
}

class _DailyMonthlyScoreScreenState extends State<DailyMonthlyScoreScreen> {
  final navigatorController = Get.find<NavigatorController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger a refresh action if needed
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(widget.classId)],
          ),
        ),
      ),
    );
  }
}
