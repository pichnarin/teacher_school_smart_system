
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_mode_badge.dart';
import 'header_icon.dart';

class AttendanceHeader extends StatelessWidget {
  final String date;
  final bool isUpdateMode;

  const AttendanceHeader({
    super.key,
    required this.date,
    required this.isUpdateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade600, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
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
              HeaderIcon(icon: Icons.how_to_reg),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'ការគ្រប់គ្រងអវត្ត',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isUpdateMode) const EditModeBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'កំណត់ត្រាអវត្តមានសម្រាប់ថ្នាក់ នៅថ្ងៃ $date',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}