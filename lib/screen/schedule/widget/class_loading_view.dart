
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassesLoadingView extends StatelessWidget {
  final String currentDate;

  const ClassesLoadingView({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CircularProgressIndicator(color: Colors.purple.shade400),
          const SizedBox(height: 16),
          Text(
            'Loading classes for $currentDate...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}