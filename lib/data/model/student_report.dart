import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/model/daily_evaluation.dart';
import 'package:pat_asl_portal/data/model/score.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';
import 'dto/daily_evaluation_dto.dart';

class StudentReport {
  final String classId;
  final String studentId;
  final String studentName;
  final String studentNumber;
  final String subjectName;
  final String subjectLevel;
  final String roomName;
  final String reportMonth;
  final String reportYear;
  final AttendanceReport attendanceReport;
  final List<Score> studentScores;
  final List<DailyEvaluation> dailyEvaluations;
  final ReportSummary reportSummary;

  const StudentReport({
    required this.classId,
    required this.studentId,
    required this.studentName,
    required this.studentNumber,
    required this.subjectName,
    required this.subjectLevel,
    required this.roomName,
    required this.reportMonth,
    required this.reportYear,
    required this.attendanceReport,
    required this.studentScores,
    required this.dailyEvaluations,
    required this.reportSummary,
  });

  @override
  String toString() {
    return 'StudentReport{'
        'classId: $classId, '
        'studentId: $studentId, '
        'studentName: $studentName, '
        'studentNumber: $studentNumber, '
        'subjectName: $subjectName, '
        'subjectLevel: $subjectLevel, '
        'roomName: $roomName, '
        'reportMonth: $reportMonth, '
        'reportYear: $reportYear, '
        'attendanceReport: $attendanceReport, '
        'studentScores: $studentScores, '
        'dailyEvaluations: $dailyEvaluations'
        ', reportSummary: $reportSummary'
        '}';
  }
}

class StudentReportDTO {
  final String classId;
  final String studentId;
  final String studentName;
  final String studentNumber;
  final String subjectName;
  final String subjectLevel;
  final String roomName;
  final String reportMonth;
  final String reportYear;
  final AttendanceReport attendanceReport;
  final List<Score> studentScores;
  final List<DailyEvaluationDTO> dailyEvaluationDTO;
  final ReportSummary reportSummary;

  const StudentReportDTO({
    required this.classId,
    required this.studentId,
    required this.studentName,
    required this.studentNumber,
    required this.subjectName,
    required this.subjectLevel,
    required this.roomName,
    required this.reportMonth,
    required this.reportYear,
    required this.attendanceReport,
    required this.studentScores,
    required this.dailyEvaluationDTO,
    required this.reportSummary,
  });

  factory StudentReportDTO.fromJson(Map<String, dynamic> json) {
    final attendanceJson = json['attendance'];
    final attendanceReport =
        attendanceJson is Map<String, dynamic>
            ? AttendanceReport.fromJson(attendanceJson)
            : AttendanceReport.empty();

    final exams =
        (json['exams'] as List?)?.whereType<Map<String, dynamic>>().toList() ??
        [];

    final evaluations =
        (json['evaluations'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        [];

    return StudentReportDTO(
      classId: json['class_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentNumber: json['student_number'] ?? '',
      subjectName: json['subject'] ?? '',
      subjectLevel: json['subject_level'] ?? '',
      roomName: json['room_name'] ?? '',
      reportMonth: json['month'] ?? '',
      reportYear: json['year'] ?? '',
      attendanceReport: attendanceReport,
      studentScores: exams.map((e) => Score.fromJson(e)).toList(),
      dailyEvaluationDTO:
          evaluations.map((e) => DailyEvaluationDTO.fromJson(e)).toList(),
      reportSummary: ReportSummary.fromJson(json['report'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'student_id': studentId,
      'student_name': studentName,
      'student_number': studentNumber,
      'subject_name': subjectName,
      'subject_level': subjectLevel,
      'room_name': roomName,
      'report_month': reportMonth,
      'report_year': reportYear,
      'attendance_report': attendanceReport.toJson(),
      'student_scores': studentScores.map((score) => score.toJson()).toList(),
      'daily_evaluations':
          dailyEvaluationDTO.map((evaluation) => evaluation.toJson()).toList(),
    };
  }

  StudentReport toStudentReport() {
    return StudentReport(
      classId: classId,
      studentId: studentId,
      studentName: studentName,
      studentNumber: studentNumber,
      subjectName: subjectName,
      subjectLevel: subjectLevel,
      roomName: roomName,
      reportMonth: reportMonth,
      reportYear: reportYear,
      attendanceReport: attendanceReport,
      studentScores: studentScores,
      dailyEvaluations:
          dailyEvaluationDTO.map((e) => e.toDailyEvaluation()).toList(),
      reportSummary: reportSummary,
    );
  }

  static StudentReportDTO fromStudentReport(StudentReport report) {
    return StudentReportDTO(
      classId: report.classId,
      studentId: report.studentId,
      studentName: report.studentName,
      studentNumber: report.studentNumber,
      subjectName: report.subjectName,
      subjectLevel: report.subjectLevel,
      roomName: report.roomName,
      reportMonth: report.reportMonth,
      reportYear: report.reportYear,
      attendanceReport: report.attendanceReport,
      studentScores: report.studentScores,
      dailyEvaluationDTO: report.dailyEvaluations.map((e) => DailyEvaluationDTO.fromDailyEvaluation(e)).toList(),
      reportSummary: report.reportSummary,
    );
  }

  @override
  String toString() {
    return 'StudentReportDTO{'
        'classId: $classId, '
        'studentId: $studentId, '
        'studentName: $studentName, '
        'studentNumber: $studentNumber, '
        'subjectName: $subjectName, '
        'subjectLevel: $subjectLevel, '
        'roomName: $roomName, '
        'reportMonth: $reportMonth, '
        'reportYear: $reportYear, '
        'attendanceReport: $attendanceReport, '
        'studentScores: $studentScores, '
        'dailyEvaluationDTO: $dailyEvaluationDTO'
        ', reportSummary: $reportSummary'
        '}';
  }
}

class AttendanceReport {
  final int present;
  final int late;
  final int absent;
  final int excused;

  AttendanceReport({
    required this.present,
    required this.late,
    required this.absent,
    required this.excused,
  });

  factory AttendanceReport.empty() {
    return AttendanceReport(present: 0, late: 0, absent: 0, excused: 0);
  }

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      present: json['present'] ?? 0,
      late: json['late'] ?? 0,
      absent: json['absent'] ?? 0,
      excused: json['excused'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'late': late,
      'absent': absent,
      'excused': excused,
    };
  }
}

class ReportSummary {
  final String id;
  final int reportMonth;
  final int reportYear;
  final double attendancePenalty;
  final double dailyEvaluationPenalty;
  final double totalPenalty;
  final double overallScore;
  final double maxScore;

  const ReportSummary({
    required this.id,
    required this.reportMonth,
    required this.reportYear,
    required this.attendancePenalty,
    required this.dailyEvaluationPenalty,
    required this.totalPenalty,
    required this.overallScore,
    required this.maxScore,
  });

  String get reportPeriod => '$reportMonth/$reportYear';
  double get percentage => (overallScore / maxScore) * 100;

  String get grade {
    final percentage = this.percentage;
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return ReportSummary(
      id: json['id'] ?? '',
      reportMonth: parseInt(json['month']),
      reportYear: parseInt(json['year']),
      attendancePenalty: (json['attendance_penalty'] ?? 0).toDouble(),
      dailyEvaluationPenalty: (json['daily_evaluation_penalty'] ?? 0).toDouble(),
      totalPenalty: (json['total_penalty'] ?? 0).toDouble(),
      overallScore: (json['overall_score'] ?? 0).toDouble(),
      maxScore: (json['max_score'] ?? 0).toDouble(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': reportMonth,
      'year': reportYear,
      'attendance_penalty': attendancePenalty,
      'daily_evaluation_penalty': dailyEvaluationPenalty,
      'total_penalty': totalPenalty,
      'overall_score': overallScore,
      'max_score': maxScore,
    };
  }
}
