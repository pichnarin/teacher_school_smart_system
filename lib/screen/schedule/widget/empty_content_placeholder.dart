import 'package:flutter/material.dart';

class EmptyContentPlaceholder extends StatelessWidget {
  const EmptyContentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Select a date to view classes',
        style: TextStyle(color: Colors.grey[600], fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}