
import 'package:flutter/material.dart';

class DailyEvaluationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DailyEvaluationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'ការវាយតម្លៃប្រចាំថ្ងៃ',
        style: TextStyle(
          color: Colors.green.shade700,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}