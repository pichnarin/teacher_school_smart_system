import 'package:flutter/material.dart';

class EmptyScoresView extends StatelessWidget {
  final String month;
  final int year;
  final VoidCallback onCreateScores;

  const EmptyScoresView({
    super.key,
    required this.month,
    required this.year,
    required this.onCreateScores,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'មិនទាន់បានកត់ត្រាពិន្ទុប្រឡងនៅឡើយទេ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'វាហាក់ដូចជាមិនមានពិន្ទុដែលបានបញ្ចូលសម្រាប់ $month $year.\nសូមពិនិត្យមើលឡើងវិញនៅពេលក្រោយ ឬបង្កើតពិន្ទុប្រឡងសម្រាប់ខែបច្ចុប្បន្នុ៕',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateScores,
            icon: const Icon(Icons.create),
            label: const Text('បង្កើតបន្ទុះសិស្ស'),
          ),
        ],
      ),
    );
  }
}