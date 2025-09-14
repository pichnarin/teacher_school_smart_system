
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../data/model/class_session.dart';
import '../../../util/formatter/time_of_the_day_formater.dart';
import '../../enroll_student_attendance/class_detail_screen.dart';
import '../../home/widget/suggest_class_card.dart';
import '../../navigator/navigator_controller.dart';

class ClassCard extends StatelessWidget {
  final ClassSession classItem;

  const ClassCard({super.key, required this.classItem});

  @override
  Widget build(BuildContext context) {
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
        sessionType: classItem.sessionType.sessionType,
        status: classItem.status,
        statusAtBottom: true,
        classGrade: classItem.classInfo.subjectLevel.name.toUpperCase(),
        classSubject: classItem.subject.subjectName.toUpperCase(),
        classDate: classItem.sessionDate,
        startTime: TimeFormatter.format(classItem.startTime),
        endTime: TimeFormatter.format(classItem.endTime),
        totalStudents: classItem.studentCount?.toString() ?? '0',
        onTap: () => _navigateToClassDetail(context),
      ),
    );
  }

  void _navigateToClassDetail(BuildContext context) {
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
  }
}