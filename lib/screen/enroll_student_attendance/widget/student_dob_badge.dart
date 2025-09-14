
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDobBadge extends StatelessWidget {
  final DateTime dob;

  const StudentDobBadge({
    super.key,
    required this.dob,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
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
            DateFormat('MMM dd, yyyy').format(dob),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}