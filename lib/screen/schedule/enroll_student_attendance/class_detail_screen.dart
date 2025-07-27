import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/schedule/daily_evaluation/daily_evaluation_create_or_patch_screen.dart';
import 'package:pat_asl_portal/screen/schedule/daily_evaluation/daily_evaluation_screen.dart';
import 'package:pat_asl_portal/screen/schedule/enroll_student_attendance/attendance_screen.dart';
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
import '../../global_widget/base_screen.dart';
import '../../home/widget/suggest_class_card.dart';
import '../../navigator/navigator_controller.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<ClassSessionBloc>().add(FetchClassSessionById(widget.classSessionId));
    // debugPrint('Class ID: ${widget.classSessionId}');
    context.read<EnrollmentBloc>().add(
      FetchEnrollmentsByClassId(widget.classId),
    );

    debugPrint('Fetching enrollments for class ID: ${widget.classId}');
    debugPrint('Fetching class session by ID: ${widget.classSessionId}');
    debugPrint('Session Date: ${widget.sessionDate}');
    debugPrint('Start Time: ${widget.startTime}');
    debugPrint('End Time: ${widget.endTime}');

  }

  final navigatorController = Get.find<NavigatorController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ClassSessionBloc>().add(FetchClassSessionById(widget.classSessionId));
          context.read<EnrollmentBloc>().add(
            FetchEnrollmentsByClassId(widget.classId),
          );
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Enhanced Header with gradient background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.class_,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'ការត្រួតពិនិត្យថ្នាក់',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'កំណត់ត្រាថ្នាក់សម្រាប់កាលវិភាគ ${widget.sessionDate}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enhanced Section Header for Class Details
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SectionHeader(title: "Class Details")),
              ],
            ),

            const SizedBox(height: 12),

            // Enhanced Class Details Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(4),
                child: BlocBuilder<ClassSessionBloc, ClassSessionState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ClassStatus.loading:
                        return const LoadingState();
                      case ClassStatus.error:
                        return ErrorState(errorMessage: state.errorMessage ?? 'Unknown error');
                      case ClassStatus.loaded:
                        final classItem = state.classFilterById;
                        if (classItem != null) {
                          return _buildClassDetails(classItem);
                        }
                        return const EmptyState();
                      default:
                        return const EmptyState();
                    }
                  },
                )
            ),


            const SizedBox(height: 24),

            // Enhanced Section Header for Students List
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SectionHeader(
                    title: "ចំនួនសិស្ស",
                    buttonText: Text("ការកំណត់ត្រាអវត្តមាន"),
                    onSeeAll: () async {

                      // Fetch the session for the class and date (active or not)
                      context.read<SessionBloc>().add(FetchActiveSession(widget.classId, widget.sessionDate, widget.startTime, widget.endTime));

                      await Future.delayed(const Duration(milliseconds: 300)); // Wait for state update

                      final sessionState = context.read<SessionBloc>().state;
                      final session = sessionState is SessionLoaded ? sessionState.session : null;
                      debugPrint('Session: ${session?.sessionId}, Start: ${session?.startTime}, End: ${session?.endTime}');


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

                    },
                  ),

                ),

                TextButton(
                  onPressed: () async {
                    context.read<DailyEvaluationBloc>().add(
                      CheckDailyEvaluationExist(widget.classSessionId),
                    );
                    await Future.delayed(const Duration(milliseconds: 300)); // Wait for state update

                    final dailyEvaluationState = context.read<DailyEvaluationBloc>().state;
                    if (dailyEvaluationState.exists == true) {
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
                            isPatching: true,
                          ),
                        ),
                      );
                    } else {
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
                            isPatching: false,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'ការវាយតម្លៃប្រចាំថ្ងៃ',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            // Enhanced Students List
            BlocBuilder<EnrollmentBloc, EnrollmentState>(
              builder: (context, state) {
                if (state.status == EnrollmentStatus.loading) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text(
                              'Loading students...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state.status == EnrollmentStatus.error) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade400,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${state.errorMessage}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state.enrollments != null &&
                    state.enrollments!.isNotEmpty) {
                  final theme = Theme.of(context).colorScheme;

                  return Column(
                    children: [
                      // Student count header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.groups,
                              color: Colors.blue.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${state.enrollments!.length} សិស្សបានចុះឈ្មោះ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Enhanced student list
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.enrollments!.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final enrollmentWithStudent =
                              state.enrollments![index];
                          final student = enrollmentWithStudent.student;

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade50],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Enhanced Avatar with gradient border
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.primary,
                                            theme.primary.withValues(
                                              alpha: 0.7,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: theme.primary
                                              .withValues(alpha: 0.1),
                                          child: Text(
                                            student.firstName[0].toUpperCase() +
                                                student.lastName[0]
                                                    .toUpperCase(),
                                            style: TextStyle(
                                              color: theme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Enhanced Student Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Name + ID Row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  student.getFullName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      theme.primaryContainer,
                                                      theme.primaryContainer
                                                          .withValues(
                                                            alpha: 0.8,
                                                          ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  "ID: ${student.studentNumber}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        theme
                                                            .onPrimaryContainer,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 12),

                                          // Enhanced DOB with better styling
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.cake,
                                                  size: 16,
                                                  color: Colors.orange.shade700,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  DateFormat(
                                                    'MMM dd, yyyy',
                                                  ).format(student.dob),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.orange.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: Colors.amber.shade700,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'មិនមានសិស្សចុះឈ្មោះទេ',
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDetails(ClassSession classItem) {

    return SuggestedClassCard(
      sessionType: classItem.sessionType.sessionType,
      status: classItem.status,
      classGrade: classItem.classInfo.subjectLevel.name.toUpperCase(),
      classSubject: classItem.subject.subjectName.toUpperCase(),
      classDate: classItem.sessionDate,
      startTime: TimeFormatter.format(classItem.startTime),
      endTime: TimeFormatter.format(classItem.endTime),
      totalStudents: classItem.studentCount.toString(),
    );
  }


}
