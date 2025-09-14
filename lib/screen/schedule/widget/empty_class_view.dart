import 'package:flutter/material.dart';

class EmptyClassesView extends StatelessWidget {
  final String currentDate;

  const EmptyClassesView({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'បច្ចុប្បន្នអ្នកមិនមានថ្នាក់បង្រៀនសម្រាប់ថ្ងៃនេះទេ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentDate,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}