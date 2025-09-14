import 'package:flutter/material.dart';
import '../../../data/model/session.dart';
import 'package:intl/intl.dart';

enum ClassSessionStatus { scheduled, inProgress, completed, unknown }

extension ClassSessionStatusKhmer on ClassSessionStatus {
  String get khmer {
    switch (this) {
      case ClassSessionStatus.scheduled:
        return 'រង់ចាំ';
      case ClassSessionStatus.inProgress:
        return 'កំពុងដំណើរការ';
      case ClassSessionStatus.completed:
        return 'បញ្ចប់';
      default:
        return 'មិនស្គាល់';
    }
  }
}

ClassSessionStatus statusFromString(String? status) {
  switch (status?.toLowerCase()) {
    case 'scheduled':
      return ClassSessionStatus.scheduled;
    case 'in_progress':
      return ClassSessionStatus.inProgress;
    case 'completed':
      return ClassSessionStatus.completed;
    default:
      return ClassSessionStatus.unknown;
  }
}

final Map<String, String> khmerMonths = {
  'January': 'មករា',
  'February': 'កុម្ភៈ',
  'March': 'មីនា',
  'April': 'មេសា',
  'May': 'ឧសភា',
  'June': 'មិថុនា',
  'July': 'កក្កដា',
  'August': 'សីហា',
  'September': 'កញ្ញា',
  'October': 'តុលា',
  'November': 'វិច្ឆិកា',
  'December': 'ធ្នូ',
};

String formatDateToKhmer(String dateStr) {
  final date = DateTime.parse(dateStr);
  final formatted = DateFormat('MMMM d, y').format(date); // e.g., August 15, 2025
  final monthEn = DateFormat('MMMM').format(date);
  final monthKh = khmerMonths[monthEn] ?? monthEn;
  return formatted.replaceFirst(monthEn, monthKh);
}

class SuggestedClassCard extends StatelessWidget {
  final SessionType? sessionType;
  final String? classGrade;
  final String? roomName;
  final String? classSubject;
  final DateTime? classDate;
  final String? startTime;
  final String? endTime;
  final String? totalStudents;
  final String? status;
  final VoidCallback? onTap;
  final bool statusAtBottom;

  const SuggestedClassCard({
    super.key,
    this.sessionType,
    this.classGrade,
    this.roomName,
    this.classSubject,
    this.classDate,
    this.startTime,
    this.endTime,
    this.status,
    this.totalStudents,
    this.onTap,
    this.statusAtBottom = false,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue.shade600;
      case 'in_progress':
        return Colors.orange.shade700;
      case 'completed':
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

Widget _buildStatusBadge() {
  if (status == null) return const SizedBox.shrink();
  final color = _getStatusColor(status!);
  final khmerStatus = statusFromString(status).khmer;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color),
    ),
    child: Text(
      khmerStatus,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    ),
  );
}

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = classDate != null
        ? formatDateToKhmer(classDate!.toIso8601String())
        : 'N/A';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      sessionType?.name ?? 'Session',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      if (!statusAtBottom && status != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildStatusBadge(),
                        ),
                      Icon(Icons.class_, color: Colors.blue.shade300),
                    ],
                  ),
                ],
              ),

              if (classSubject != null) ...[
                const SizedBox(height: 8),
                Text(
                  'មុខវិជ្ជា: $classSubject',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (classGrade != null || roomName != null) ...[
                const SizedBox(height: 4),
                if (classGrade != null)
                  Text(
                    'កំរិត: ${classGrade ?? 'N/A'}',
                    style:
                    const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                if (roomName != null && roomName!.trim().isNotEmpty)
                  Text(
                    'បន្ទប់: $roomName',
                    style:
                    const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],

              const SizedBox(height: 12),

              // Date & Time Rows
              if (classDate != null)
                _buildInfoRow(Icons.calendar_today, formattedDate),
              if (startTime != null && endTime != null)
                _buildInfoRow(Icons.access_time, '$startTime - $endTime'),

              // Students
              _buildInfoRow(
                Icons.group,
                (totalStudents == null || totalStudents == '0')
                    ? 'មិនមានសិស្ស'
                    : 'សិស្ស $totalStudents នាក់',
              ),

              if (statusAtBottom && status != null) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildStatusBadge(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
