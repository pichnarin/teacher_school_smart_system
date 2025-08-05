import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_event.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';
import 'package:pat_asl_portal/data/model/session.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/global_widget/section_header.dart';
import 'package:pat_asl_portal/screen/schedule/widget/date_picker.dart';
import '../../bloc/class_session/class_session_bloc.dart';
import '../../bloc/class_session/class_session_state.dart';
import '../../data/model/class.dart';
import '../../util/formatter/time_of_the_day_formater.dart';
import '../enroll_student_attendance/class_detail_screen.dart';
import '../home/widget/suggest_class_card.dart';
import '../navigator/navigator_controller.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final navigatorController = Get.find<NavigatorController>();
  final datePickerController = DatePickerController();

  late String currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    context.read<ClassSessionBloc>().add(FetchClassSessionsByDate(currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ClassSessionBloc>().add(FetchClassSessionsByDate(currentDate));
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Enhanced Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'កាលវិភាគថ្នាក់',
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
                    'គ្រប់គ្រងថ្នាក់ និងសកម្មភាពប្រចាំថ្ងៃរបស់អ្នក',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Enhanced Date Picker with FIXED onDateSelected
            GestureDatePicker(
              controller: datePickerController,
                onDateSelected: (date) {
                  final formattedDate = datePickerController.formatDate();
                  if (formattedDate != null) {
                    setState(() {
                      currentDate = formattedDate;
                    });
                    context.read<ClassSessionBloc>().add(FetchClassSessionsByDate(formattedDate));
                  }
                }

            ),

            const SizedBox(height: 24),

            // Enhanced Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.class_,
                    color: Colors.indigo,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SectionHeader(title: "កាលវិភាគសំរាប់ $currentDate"),
                ),
                // Quick stats
                BlocBuilder<ClassSessionBloc, ClassSessionState>(
                  builder: (context, state) {
                    final classCount = state.classFilterByDate?.length ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$classCount ថ្នាក់',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Enhanced Class List
            BlocBuilder<ClassSessionBloc, ClassSessionState>(
              builder: (context, state) {
                switch (state.status) {
                  case ClassStatus.loading:
                    return Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: Colors.purple.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading classes for $currentDate...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );

                  case ClassStatus.error:
                    return Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading classes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage ?? 'Something went wrong',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );

                  case ClassStatus.loaded:
                    if (state.classFilterByDate == null || state.classFilterByDate!.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'បច្ចុប្បន្នអ្នកមិនមានថ្នាក់បង្រៀនសម្រាប់ថ្ងៃនេះទេ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildClassList(state.classFilterByDate!.cast<ClassSession>());

                  default:
                    return Container(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Select a date to view classes',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList(List<ClassSession> classes) {
    return Column(
      children: [
        // Summary stats
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade50, Colors.indigo.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.class_,
                label: 'Total Classes',
                value: classes.length.toString(),
                color: Colors.indigo,
              ),
              Container(height: 40, width: 1, color: Colors.indigo.shade200),
              _buildStatItem(
                icon: Icons.people,
                label: 'Total Students',
                value:
                      classes.isEmpty
                        ? '0'
                        : classes.fold<int>(
                            0,
                            (sum, cls) => sum + (cls.studentCount ?? 0),
                          ).toString(),
                color: Colors.green,
              ),
              Container(height: 40, width: 1, color: Colors.indigo.shade200),
              _buildStatItem(
                icon: Icons.schedule,
                label: 'Duration',
                value: classes.isEmpty
                    ? '0h'
                    : () {
                  final totalMinutes = classes.fold<int>(
                    0,
                        (sum, cls) => sum + TimeFormatter.calculateDurationFromTimeOfDay(
                      cls.startTime,  // These are TimeOfDay objects
                      cls.endTime,    // These are TimeOfDay objects
                    ),
                  );

                  final hours = totalMinutes / 60;

                  // Show whole hours without decimal if it's exact
                  if (totalMinutes % 60 == 0) {
                    return '${hours.toInt()}h';
                  } else {
                    return '${hours.toStringAsFixed(1)}h';
                  }
                }(),
                color: Colors.orange,
              ),
            ],
          ),
        ),

        // Enhanced Grid View
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classItem = classes[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SuggestedClassCard(
                sessionType: SessionType.lecture,
                status: classItem.status,
                statusAtBottom: true,
                classGrade: classItem.classInfo.subjectLevel.name.toUpperCase(),
                classSubject: classItem.subject.subjectName.toUpperCase(),
                classDate: classItem.sessionDate,
                startTime: TimeFormatter.format(classItem.startTime),
                endTime: TimeFormatter.format(classItem.endTime),
                totalStudents: classItem.studentCount?.toString() ?? '0',
                onTap: () {
                  Get.find<NavigatorController>().pushToCurrentTab(
                    ClassDetailScreen(
                      classId: classItem.classInfo.classId,
                      classSessionId: classItem.sessionId,
                      sessionDate: DateFormat('yyyy-MM-dd').format(classItem.sessionDate),
                      startTime: TimeFormatter.format(classItem.startTime),
                      endTime: TimeFormatter.format(classItem.endTime),
                      subjectId: classItem.subject.subjectId,
                      subjectName: classItem.subject.subjectName,
                      subjectLevelId: classItem.classInfo.subjectLevel.getId,
                      subjectLevelName: classItem.classInfo.subjectLevel.name ?? 'N/A',
                      roomName: classItem.room.roomName,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade200,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}