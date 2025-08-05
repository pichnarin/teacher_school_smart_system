import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/bloc/class/class_state.dart';
import 'package:pat_asl_portal/data/model/student_report.dart';
import 'package:pat_asl_portal/data/model/score.dart';
import 'package:pat_asl_portal/data/model/daily_evaluation.dart';
import 'package:intl/intl.dart';

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
                      child: const Text('Retry'),
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
                  child: _InfoTile(
                    title: 'Subject',
                    value: '${report.subjectName} (${report.subjectLevel})',
                  ),
                ),
                Expanded(
                  child: _InfoTile(title: 'Room', value: report.roomName),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: 'Report Period',
                    value: '${report.reportMonth}/${report.reportYear}',
                  ),
                ),
                Expanded(
                  child: _InfoTile(title: 'Class Name', value: report.subjectLevel),
                ),
              ],
            ),

            const Divider(height: 24),

            // Attendance Summary
            SectionHeader(title: 'Attendance Summary'),
            const SizedBox(height: 8),
            _AttendanceSummary(attendanceReport: report.attendanceReport),

            if (_expanded) ...[
              const Divider(height: 24),

              // Exam Scores
              SectionHeader(title: 'Exam Scores'),
              const SizedBox(height: 8),
              report.studentScores.isEmpty
                  ? const Text('No exam scores available')
                  : _ExamScoresTable(scores: report.studentScores),

              const Divider(height: 24),

              // Daily Evaluations
              SectionHeader(title: 'Daily Evaluations'),
              const SizedBox(height: 8),
              report.dailyEvaluations.isEmpty
                  ? const Text('No daily evaluations available')
                  : _DailyEvaluationsTable(
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

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _AttendanceSummary extends StatelessWidget {
  final AttendanceReport attendanceReport;

  const _AttendanceSummary({required this.attendanceReport});

  @override
  Widget build(BuildContext context) {
    final total =
        attendanceReport.present +
        attendanceReport.late +
        attendanceReport.absent +
        attendanceReport.excused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _AttendanceIndicator(
              label: 'Present',
              count: attendanceReport.present,
              color: Colors.green,
            ),
            _AttendanceIndicator(
              label: 'Late',
              count: attendanceReport.late,
              color: Colors.amber,
            ),
            _AttendanceIndicator(
              label: 'Absent',
              count: attendanceReport.absent,
              color: Colors.red,
            ),
            _AttendanceIndicator(
              label: 'Excused',
              count: attendanceReport.excused,
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (total > 0)
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
            minHeight: 8,
          ),
        if (total > 0)
          Stack(
            children: [
              LinearProgressIndicator(
                value: attendanceReport.present / total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 8,
              ),
              LinearProgressIndicator(
                value:
                    (attendanceReport.present + attendanceReport.late) / total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
              LinearProgressIndicator(
                value:
                    (attendanceReport.present +
                        attendanceReport.late +
                        attendanceReport.absent) /
                    total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 8,
              ),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          'Total Sessions: $total',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _AttendanceIndicator extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _AttendanceIndicator({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            '$label: $count',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ExamScoresTable extends StatelessWidget {
  final List<Score> scores;

  const _ExamScoresTable({required this.scores});

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
            DataColumn(label: Text('Score')),
            DataColumn(label: Text('Max')),
            DataColumn(label: Text('Percentage')),
            DataColumn(label: Text('Grade')),
            DataColumn(label: Text('Remarks')),
          ],
          rows:
              scores.map((score) {
                return DataRow(
                  cells: [
                    DataCell(Text(score.examPeriod)),
                    DataCell(Text('${score.score}')),
                    DataCell(Text('${score.maxScore}')),
                    DataCell(Text('${score.percentage.toStringAsFixed(1)}%')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getGradeColor(score.grade),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          score.grade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(score.remarks ?? '-')),
                  ],
                );
              }).toList(),
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

class _DailyEvaluationsTable extends StatelessWidget {
  final List<DailyEvaluation> evaluations;

  const _DailyEvaluationsTable({required this.evaluations});

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
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Homework')),
            DataColumn(label: Text('Clothing')),
            DataColumn(label: Text('Attitude')),
            DataColumn(label: Text('Class Activity')),
            DataColumn(label: Text('Overall Score')),
          ],
          rows:
              evaluations.map((evaluation) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        DateFormat(
                          'MM/dd/yyyy',
                        ).format(evaluation.classSession.sessionDate),
                      ),
                    ),
                    DataCell(_getStatusWidget(evaluation.homework)),
                    DataCell(_getStatusWidget(evaluation.clothing)),
                    DataCell(_getStatusWidget(evaluation.attitude)),
                    DataCell(Text('${evaluation.classActivity}')),
                    DataCell(
                      Text(
                        '${evaluation.overallScore}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(evaluation.overallScore),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _getStatusWidget(String status) {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'good':
      case 'excellent':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'fair':
      case 'average':
        icon = Icons.check;
        color = Colors.amber;
        break;
      case 'poor':
      case 'bad':
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(status),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.amber;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
