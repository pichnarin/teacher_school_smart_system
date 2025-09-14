import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamScoreHeader extends StatelessWidget {
  final String subjectName;
  final String subjectLevelName;

  const ExamScoreHeader({
    super.key,
    required this.subjectName,
    required this.subjectLevelName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.15),
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
              Icon(Icons.score, color: colorScheme.onPrimary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'កំណត់បន្ទុះសំរាប់ថ្នាក់ $subjectName ($subjectLevelName)',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'មើលបន្ទុះសិស្សតាម ខែ និង ឆ្នាំ',
            style: TextStyle(
              color: colorScheme.onPrimary.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}