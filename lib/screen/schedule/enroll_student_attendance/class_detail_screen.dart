import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/schedule/enroll_student_attendance/attendance_screen.dart';

import '../../../bloc/class/class_bloc.dart';
import '../../../bloc/class/class_event.dart';
import '../../../bloc/class/class_state.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import '../../../data/model/class.dart';
import '../../../util/formatter/time_of_the_day_formater.dart';
import '../../global_widget/base_screen.dart';
import '../../home/widget/suggest_class_card.dart';
import '../../navigator/navigator_controller.dart';

class ClassDetailScreen extends StatefulWidget {
  final String classId;

  const ClassDetailScreen({super.key, required this.classId});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClassBloc>().add(FetchClassById(widget.classId));
    context.read<EnrollmentBloc>().add(
      FetchEnrollmentsByClassId(widget.classId),
    );
  }

  final navigatorController = Get.find<NavigatorController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          //first section show the class detail card
          //second section show the list of student that enrolled in this class
          //in the list of student have a enroll attendance button teacher to mark student attendance screen
          //mark student attendance screen have 2 filter grid and list
          const SizedBox(height: 20),

          SectionHeader(title: "Class Details"),

          const SizedBox(height: 10),

          BlocBuilder<ClassBloc, ClassState>(
            builder: (context, state) {
              if (state.status == ClassStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == ClassStatus.error) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              } else if (state.status == ClassStatus.loaded &&
                  state.classFilterById != null &&
                  state.classFilterById!.isNotEmpty) {
                final classItem = state.classFilterById!.first;
                return _buildClassDetails(classItem);
              }
              return const Center(child: Text('No data available'));
            },
          ),

          const SizedBox(height: 20),

          SectionHeader(title: "List of Students", onSeeAll: () async {
            final result = await navigatorController.navigatorKeys[
            navigatorController.selectedIndex.value
            ].currentState?.push<bool>(
              MaterialPageRoute(
                builder: (_) => AttendanceScreen(classId: widget.classId, isEditMode: true,),
              ),
            );

            if (result == true) {
              // Refresh enrollment list when attendance is submitted successfully
              context.read<EnrollmentBloc>().add(
                FetchEnrollmentsByClassId(widget.classId),
              );
            }
          },
          ),

          const SizedBox(height: 10),

          BlocBuilder<EnrollmentBloc, EnrollmentState>(
            builder: (context, state) {
              if (state.status == EnrollmentStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == EnrollmentStatus.error) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              } else if (state.status == EnrollmentStatus.loaded &&
                  state.enrollments != null &&
                  state.enrollments!.isNotEmpty) {
                final theme = Theme.of(context).colorScheme;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.enrollments!.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final enrollmentWithStudent = state.enrollments![index];
                    final student = enrollmentWithStudent.student;

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.primary.withOpacity(0.1),
                              child: Text(
                                student.firstName[0].toUpperCase() + student.lastName[0].toUpperCase(),
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name, ID, Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "ID: ${student.studentNumber}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: theme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // DOB only
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cake,
                                        size: 16,
                                        color: theme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'MMM dd, yyyy',
                                        ).format(student.dob),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.assignment_outlined),
                              tooltip: "View/Edit Attendance",
                              onPressed: () async {
                                final result = await navigatorController.navigatorKeys[
                                navigatorController.selectedIndex.value
                                ].currentState?.push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => AttendanceScreen(
                                      classId: widget.classId,
                                      date: DateTime.now().toIso8601String(), // Pass current date
                                      isEditMode: true,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  context.read<EnrollmentBloc>().add(
                                    FetchEnrollmentsByClassId(widget.classId),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: Text('No students enrolled in this class'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetails(Class classItem) {
    return SuggestedClassCard(
      sessionType: classItem.schedule.getSessionName,
      classGrade: classItem.classGrade,
      classSubject: classItem.schedule.subject.subjectName,
      classDate: classItem.schedule.date,
      startTime: TimeFormatter.format(classItem.schedule.startTime),
      endTime: TimeFormatter.format(classItem.schedule.endTime),
      totalStudents: classItem.studentCount?.toString() ?? '0',
      // classItem.students?.length.toString(),
    );
  }
}
