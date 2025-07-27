import 'package:flutter/material.dart';
import '../../../data/model/session.dart';
import 'package:intl/intl.dart';

class SuggestedClassCard extends StatelessWidget {
  final SessionType? sessionType;
  final String? classGrade;
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status!).withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status!)),
      ),
      child: Text(
        status!.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status!),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        classDate != null ? DateFormat.yMMMMd().format(classDate!) : 'N/A';

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!statusAtBottom)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sessionType?.name ?? 'Session',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        if (status != null) _buildStatusBadge(),
                        const SizedBox(width: 8),
                        Icon(Icons.class_, color: Colors.blue.shade300),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sessionType?.name ?? 'Session',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.class_, color: Colors.blue.shade300),
                  ],
                ),

              const SizedBox(height: 8),

              if (classSubject != null)
                Text(
                  classSubject!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              Text(
                'Grade: ${classGrade ?? 'N/A'}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(formattedDate, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '${startTime ?? '--:--'} - ${endTime ?? '--:--'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.group, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    (totalStudents == null || totalStudents == '0')
                        ? 'មិនមានសិស្ស'
                        : '$totalStudents students enrolled',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),

              if (statusAtBottom && status != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildStatusBadge()],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
