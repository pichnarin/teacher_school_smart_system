import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/bloc/class/class_state.dart';
import 'package:pat_asl_portal/data/model/student_report.dart';
import 'package:pat_asl_portal/data/model/score.dart';
import 'package:pat_asl_portal/data/model/daily_evaluation.dart';
import 'package:intl/intl.dart';
import 'package:pat_asl_portal/screen/report/widget/attendance_summary.dart';
import 'package:pat_asl_portal/screen/report/widget/daily_evaluation_table.dart';
import 'package:pat_asl_portal/screen/report/widget/exam_score_table.dart';
import 'package:pat_asl_portal/screen/report/widget/info_tile.dart';

import '../../util/helper_screen/grade.dart';
import '../global_widget/section_header.dart';

class StudentReportScreen extends StatelessWidget {
  final String classId;
  final int reportMonth;
  final int reportYear;

  const StudentReportScreen({
    super.key,
    required this.classId,
    required this.reportMonth,
    required this.reportYear,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Could implement filtering options here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtering not implemented yet')),
              );
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: BlocProvider.of<ClassBloc>(context)..add(
          FetchStudentReport(
            classId: classId,
            reportMonth: reportMonth,
            reportYear: reportYear,
          ),
        ),
        child: BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (state.status == ClassStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ClassStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'An error occurred.',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ClassBloc>().add(
                          FetchStudentReport(
                            classId: classId,
                            reportMonth: reportMonth,
                            reportYear: reportYear,
                          ),
                        );
                      },
                      child: Text('Retry $classId'),
                    ),
                  ],
                ),
              );
            }

            final reports = state.studentReports;
            if (reports == null || reports.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text('No student reports found.'),
                    const SizedBox(height: 16),
                    Text('Class ID: $classId'),
                    Text('Period: $reportMonth/$reportYear'),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final report = reports[index];
                return _StudentReportCard(report: report);
              },
            );
          },
        ),
      ),
    );
  }
}

class _StudentReportCard extends StatefulWidget {
  final StudentReport report;

  const _StudentReportCard({required this.report});

  @override
  State<_StudentReportCard> createState() => _StudentReportCardState();
}

class _StudentReportCardState extends State<_StudentReportCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final StudentReport report = widget.report;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Header
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    report.studentName.isNotEmpty
                        ? report.studentName.substring(0, 1)
                        : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.studentName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${report.studentNumber}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ],
            ),

            const Divider(height: 24),

            // Class Info
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: 'Subject',
                    value: '${report.subjectName} (${report.subjectLevel})',
                  ),
                ),
                Expanded(
                  child: InfoTile(title: 'Room', value: report.roomName),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InfoTile(
                    title: 'Report Period',
                    value: '${report.reportMonth}/${report.reportYear}',
                  ),
                ),
                Expanded(
                  child: InfoTile(title: 'Class Name', value: report.subjectLevel),
                ),
              ],
            ),

            const Divider(height: 24),

            // Attendance Summary
            SectionHeader(title: 'Attendance Summary'),
            const SizedBox(height: 8),
            AttendanceSummary(attendanceReport: report.attendanceReport),

            if (_expanded) ...[
              const Divider(height: 24),

              // Exam Scores
              SectionHeader(title: 'Exam Scores'),
              const SizedBox(height: 8),
              report.studentScores.isEmpty
                  ? const Text('No exam scores available')
                  : ExamScoresTable(scores: report.studentScores),

              const Divider(height: 24),

              // Daily Evaluations
              SectionHeader(title: 'Daily Evaluations'),
              const SizedBox(height: 8),
              report.dailyEvaluations.isEmpty
                  ? const Text('No daily evaluations available')
                  : DailyEvaluationsTable(
                    evaluations: report.dailyEvaluations,
                  ),


              const Divider(height: 24),

              //report summary
              SectionHeader(title: 'Report Summary'),
              const SizedBox(height: 8),
              _ReportSummary(reports: report.reportSummary,)

            ],

            // Show expand button if collapsed
            if (!_expanded)
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.expand_more),
                  label: const Text('Show more details'),
                  onPressed: () {
                    setState(() {
                      _expanded = true;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class _ReportSummary extends StatelessWidget {
  final ReportSummary reports;

  const _ReportSummary({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(label: Text('Exam Period')),
            DataColumn(label: Text('Attendance Penalty')),
            DataColumn(label: Text('Daily Evaluation Penalty')),
            DataColumn(label: Text('Max Score')),
            DataColumn(label: Text('Final Score')),
            DataColumn(label: Text('Final Grade')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text(reports.reportPeriod)),
                DataCell(Text('${reports.attendancePenalty}')),
                DataCell(Text('${reports.dailyEvaluationPenalty}')),
                DataCell(Text('${reports.maxScore}')),
                DataCell(Text('${reports.overallScore}')),

                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getGradeColor(reports.grade),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      reports.grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
