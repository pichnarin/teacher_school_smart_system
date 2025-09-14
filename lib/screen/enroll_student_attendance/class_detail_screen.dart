import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/class_detail_card.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/class_header_card.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/daily_evaluation_button.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/icon_section_header.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_list_section.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import '../../../bloc/class_session/class_session_bloc.dart';
import '../../../bloc/class_session/class_session_event.dart';
import '../../../bloc/class_session/class_session_state.dart';
import '../../../bloc/daily_evaluation/daily_evaluation_bloc.dart';
import '../../../bloc/daily_evaluation/daily_evaluation_event.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import '../../../bloc/get_active_class_session/session.bloc.dart';
import '../../../bloc/get_active_class_session/session_event.dart';
import '../../../bloc/get_active_class_session/session_state.dart';
import '../../../util/formatter/time_of_the_day_formater.dart';
import '../../../util/helper_screen/state_screen.dart';
import '../daily_evaluation/daily_evaluation_create_or_patch_screen.dart';
import '../global_widget/base_screen.dart';
import '../home/widget/suggest_class_card.dart';
import '../navigator/navigator_controller.dart';
import 'attendance_screen.dart';

class ClassDetailScreen extends StatefulWidget {
  final String classId;
  final String classSessionId;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String subjectName;
  final String subjectLevelName;
  final String subjectId;
  final String subjectLevelId;
  final String roomName;

  const ClassDetailScreen({
    super.key,
    required this.classId,
    required this.classSessionId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.subjectName,
    required this.subjectLevelName,
    required this.subjectId,
    required this.subjectLevelId,
    required this.roomName
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final navigatorController = Get.find<NavigatorController>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<ClassSessionBloc>().add(FetchClassSessionById(widget.classSessionId));
    context.read<EnrollmentBloc>().add(FetchEnrollmentsByClassId(widget.classId));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            ClassHeaderCard(
              title: 'ការត្រួតពិនិត្យថ្នាក់',
              subtitle: 'កំណត់ត្រាថ្នាក់សម្រាប់កាលវិភាគ ${widget.sessionDate}',
              icon: Icons.class_,
            ),

            const SizedBox(height: 24),

            // Class Details Section
            IconSectionHeader(
              title: "ព័ត៌មានថ្នាក់",
              icon: Icons.info_outline,
              iconColor: Colors.blue.shade700,
              iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
            ),

            const SizedBox(height: 12),

            // Class Details Content
            ClassDetailsCard(classSessionId: widget.classSessionId),

            const SizedBox(height: 24),

            // Students Section Header
            Row(
              children: [
                IconSectionHeader(
                  title: "ចំនួនសិស្ស",
                  icon: Icons.people,
                  iconColor: Colors.green.shade700,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  buttonText: const Text("ការកំណត់ត្រាអវត្តមាន"),
                  onSeeAll: () => _navigateToAttendanceScreen(),
                ),
                const Spacer(),
                DailyEvaluationButton(
                  onPressed: () => _navigateToDailyEvaluation(),
                )
              ],
            ),

            const SizedBox(height: 12),

            // Students List
            StudentListSection(classId: widget.classId),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToAttendanceScreen() async {
    // Fetch the session for the class and date
    context.read<SessionBloc>().add(FetchActiveSession(
      widget.classId,
      widget.sessionDate,
      widget.startTime,
      widget.endTime
    ));

    await Future.delayed(const Duration(milliseconds: 300));

    final sessionState = context.read<SessionBloc>().state;
    final session = sessionState is SessionLoaded ? sessionState.session : null;

    if (session != null) {
      final result = await navigatorController
          .navigatorKeys[navigatorController.selectedIndex.value]
          .currentState
          ?.push<bool>(
        MaterialPageRoute(
          builder: (_) => AttendanceScreen(
            classId: widget.classId,
            classSessionId: session.sessionId,
            startTime: session.startTime,
            date: session.sessionDate,
            endTime: session.endTime,
            isEditMode: true,
          ),
        ),
      );

      if (result == true) {
        context.read<EnrollmentBloc>().add(
          FetchEnrollmentsByClassId(widget.classId),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No class session found for this date.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateToDailyEvaluation() async {
    context.read<DailyEvaluationBloc>().add(
      CheckDailyEvaluationExist(widget.classSessionId),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    final dailyEvaluationState = context.read<DailyEvaluationBloc>().state;
    final isPatching = dailyEvaluationState.exists == true;

    await navigatorController.navigatorKeys[navigatorController.selectedIndex.value]
        .currentState?.push(
      MaterialPageRoute(
        builder: (_) => DailyEvaluationCreateOrPatchScreen(
          classId: widget.classId,
          classSessionId: widget.classSessionId,
          sessionDate: widget.sessionDate,
          subjectName: widget.subjectName,
          subjectLevelName: widget.subjectLevelName,
          roomName: widget.roomName,
          subjectId: widget.subjectId,
          subjectLevelId: widget.subjectLevelId,
          startTime: widget.startTime,
          endTime: widget.endTime,
          isPatching: isPatching,
        ),
      ),
    );
  }
}





























