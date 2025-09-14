
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentCountHeader extends StatelessWidget {
  final int count;

  const StudentCountHeader({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.groups,
            color: Colors.blue.shade700,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            '$count សិស្សបានចុះឈ្មោះ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}